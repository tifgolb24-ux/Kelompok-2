/**
 * BisaGym — ESP32-CAM (CameraWebServer)
 * =====================================================================
 * Berbasis logika official CameraWebServer dari Espressif yang terbukti
 * berhasil streaming di ESP32-CAM AI-Thinker + OV2640.
 *
 * Endpoint:
 *   GET http://<ip>:81/stream   → MJPEG live stream  (preview wajah)
 *   GET http://<ip>/capture     → Satu frame JPEG     (untuk AI biometrik)
 *   GET http://<ip>/size?v=<N>  → Ganti resolusi kamera
 *   GET http://<ip>/status      → Status JSON (tes koneksi dari web)
 *   GET http://<ip>/             → Halaman kontrol sederhana
 *
 * Board  : AI-Thinker ESP32-CAM
 * Sensor : OV2640
 * =====================================================================
 */

#include <Arduino.h>
#include "esp_camera.h"
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <ESPmDNS.h>
#include "esp_http_server.h"

// ===========================
// WiFi (Hotspot HP 2.4 GHz)
// ===========================
const char *ssid     = "REDMI Note 15 5G";
const char *password = "mimpiIBADAH";

// ===========================
// Cloud Relay (Railway)
// ===========================
const char *railwayUploadUrl = "https://esp32cam-production-704ea82e.up.railway.app/upload";
const int uploadIntervalMs   = 200;
TaskHandle_t uploadTaskHandle = NULL;
bool cloudUploadActive       = true;

// ===========================
// Pin kamera AI-Thinker ESP32-CAM
// ===========================
#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27
#define Y9_GPIO_NUM       35
#define Y8_GPIO_NUM       34
#define Y7_GPIO_NUM       39
#define Y6_GPIO_NUM       36
#define Y5_GPIO_NUM       21
#define Y4_GPIO_NUM       19
#define Y3_GPIO_NUM       18
#define Y2_GPIO_NUM        5
#define VSYNC_GPIO_NUM    25
#define HREF_GPIO_NUM     23
#define PCLK_GPIO_NUM     22

// LED Flash (GPIO 4 untuk AI-Thinker)
#define LED_GPIO_NUM       4

httpd_handle_t httpServer   = NULL;  // port 80
httpd_handle_t streamServer = NULL;  // port 81

// ---------------------------
// Halaman utama (port 80 /)
// ---------------------------
static esp_err_t index_handler(httpd_req_t *req) {
    const char *html =
        "<!DOCTYPE html><html><head><meta name='viewport' content='width=device-width,initial-scale=1'>"
        "<title>BisaGym ESP32-CAM</title></head>"
        "<body style='text-align:center;font-family:sans-serif;background:#111;color:#eee'>"
        "<h2>BisaGym ESP32-CAM</h2>"
        "<img id='cam' style='max-width:100%;border-radius:8px'>"
        "<p>Resolusi: "
        "<select onchange='setRes(this.value)'>"
        "<option value='5'>QVGA 320x240</option>"
        "<option value='8' selected>VGA 640x480</option>"
        "<option value='9'>SVGA 800x600</option>"
        "</select></p>"
        "<p><a style='color:#6cf' href='/capture' target='_blank'>Ambil foto</a> | "
        "<a style='color:#6cf' href='/status' target='_blank'>Status</a></p>"
        "<script>"
        "var base='http://'+location.hostname+':81/stream';"
        "function startStream(){document.getElementById('cam').src=base+'?t='+Date.now();}"
        "function setRes(v){document.getElementById('cam').src='';"
        "fetch('/size?v='+v).then(function(){setTimeout(startStream,800);});}"
        "startStream();"
        "</script></body></html>";
    httpd_resp_set_type(req, "text/html");
    return httpd_resp_send(req, html, HTTPD_RESP_USE_STRLEN);
}

// ---------------------------
// Ganti resolusi: /size?v=N
// ---------------------------
static esp_err_t size_handler(httpd_req_t *req) {
    char query[32], val[8];
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK &&
        httpd_query_key_value(query, "v", val, sizeof(val)) == ESP_OK) {
        int v = atoi(val);
        if (v >= FRAMESIZE_QQVGA && v <= FRAMESIZE_UXGA) {
            sensor_t *s = esp_camera_sensor_get();
            s->set_framesize(s, (framesize_t)v);
            Serial.printf("[CAM] Resolusi diganti ke: %d\n", v);
        }
    }
    httpd_resp_set_type(req, "text/plain");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, "OK", HTTPD_RESP_USE_STRLEN);
}

// ---------------------------
// Ambil 1 foto: /capture
// ---------------------------
static esp_err_t capture_handler(httpd_req_t *req) {
    camera_fb_t *fb = NULL;

    // Coba ambil frame beberapa kali (toleransi sensor lambat)
    for (int i = 0; i < 5 && !fb; i++) {
        fb = esp_camera_fb_get();
        if (!fb) vTaskDelay(150 / portTICK_PERIOD_MS);
    }
    if (!fb) {
        Serial.println("[CAM] Capture: gagal ambil frame");
        httpd_resp_send_500(req);
        return ESP_FAIL;
    }

    httpd_resp_set_type(req, "image/jpeg");
    httpd_resp_set_hdr(req, "Content-Disposition", "inline; filename=capture.jpg");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    httpd_resp_set_hdr(req, "Cache-Control", "no-cache, no-store, must-revalidate");

    esp_err_t res = httpd_resp_send(req, (const char *)fb->buf, fb->len);
    Serial.printf("[CAM] Capture OK: %u bytes\n", fb->len);
    esp_camera_fb_return(fb);
    return res;
}

// ---------------------------
// Status JSON: /status
// ---------------------------
static esp_err_t status_handler(httpd_req_t *req) {
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");

    // Tes ambil 1 frame singkat
    camera_fb_t *testFb = esp_camera_fb_get();
    bool frameOk = (testFb != NULL);
    size_t frameBytes = frameOk ? testFb->len : 0;
    if (testFb) esp_camera_fb_return(testFb);

    char json[256];
    snprintf(json, sizeof(json),
             "{\"status\":\"ready\",\"ip\":\"%s\","
             "\"psram\":%s,\"frame_ok\":%s,\"frame_bytes\":%u,"
             "\"free_heap\":%u,\"stream_url\":\"http://%s:81/stream\","
             "\"capture_url\":\"http://%s/capture\"}",
             WiFi.localIP().toString().c_str(),
             psramFound() ? "true" : "false",
             frameOk ? "true" : "false",
             (unsigned int)frameBytes,
             ESP.getFreeHeap(),
             WiFi.localIP().toString().c_str(),
             WiFi.localIP().toString().c_str());
    return httpd_resp_send(req, json, strlen(json));
}

// ---------------------------
// Streaming MJPEG: /stream (port 81)
// ---------------------------
static esp_err_t stream_handler(httpd_req_t *req) {
    esp_err_t res = httpd_resp_set_type(req, "multipart/x-mixed-replace;boundary=frame");
    if (res != ESP_OK) return res;
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    httpd_resp_set_hdr(req, "X-Framerate", "15");

    char partBuf[80];
    int gagal = 0;
    Serial.println("[STREAM] Klien terhubung");

    while (true) {
        camera_fb_t *fb = esp_camera_fb_get();
        if (!fb) {
            if (++gagal >= 30) {
                Serial.println("[STREAM] Gagal frame terlalu banyak, stop.");
                res = ESP_FAIL;
                break;
            }
            vTaskDelay(100 / portTICK_PERIOD_MS);
            continue;
        }
        gagal = 0;

        res = httpd_resp_send_chunk(req, "\r\n--frame\r\n", 12);
        if (res == ESP_OK) {
            size_t hlen = snprintf(partBuf, sizeof(partBuf),
                                   "Content-Type: image/jpeg\r\nContent-Length: %u\r\n\r\n",
                                   (unsigned)fb->len);
            res = httpd_resp_send_chunk(req, partBuf, hlen);
        }
        if (res == ESP_OK) {
            res = httpd_resp_send_chunk(req, (const char *)fb->buf, fb->len);
        }
        esp_camera_fb_return(fb);

        if (res != ESP_OK) break;  // klien menutup halaman
        vTaskDelay(30 / portTICK_PERIOD_MS);
    }
    Serial.println("[STREAM] Klien terputus");
    return res;
}

// ---------------------------
// Start Web Server
// ---------------------------
void startWebServer() {
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();
    config.max_uri_handlers = 8;
    config.stack_size = 8192;

    // Port 80: halaman utama, capture, size, status, dan stream
    config.server_port = 80;
    if (httpd_start(&httpServer, &config) == ESP_OK) {
        httpd_uri_t indexUri   = { "/",        HTTP_GET, index_handler,   NULL };
        httpd_uri_t captureUri = { "/capture", HTTP_GET, capture_handler, NULL };
        httpd_uri_t sizeUri    = { "/size",    HTTP_GET, size_handler,    NULL };
        httpd_uri_t statusUri  = { "/status",  HTTP_GET, status_handler,  NULL };
        httpd_uri_t streamUri80 = { "/stream", HTTP_GET, stream_handler,  NULL };
        httpd_register_uri_handler(httpServer, &indexUri);
        httpd_register_uri_handler(httpServer, &captureUri);
        httpd_register_uri_handler(httpServer, &sizeUri);
        httpd_register_uri_handler(httpServer, &statusUri);
        httpd_register_uri_handler(httpServer, &streamUri80);
        Serial.println("[HTTP] Web server (port 80) aktif (lengkap dengan /stream & /capture)");
    }

    // Port 81: MJPEG stream
    config.server_port = 81;
    config.ctrl_port += 1;
    if (httpd_start(&streamServer, &config) == ESP_OK) {
        httpd_uri_t streamUri = { "/stream", HTTP_GET, stream_handler, NULL };
        httpd_register_uri_handler(streamServer, &streamUri);
        Serial.println("[HTTP] Stream server (port 81) aktif");
    }
}

// ---------------------------
// Koneksi WiFi dengan retry
// ---------------------------
bool connectWiFi() {
    WiFi.mode(WIFI_STA);
    WiFi.disconnect(true);
    delay(200);

    for (int coba = 1; coba <= 3; coba++) {
        Serial.printf("[WiFi] Menghubungkan ke \"%s\" (percobaan %d/3)", ssid, coba);
        WiFi.begin(ssid, password);
        int tunggu = 0;
        while (WiFi.status() != WL_CONNECTED && tunggu < 30) {
            delay(500);
            Serial.print(".");
            tunggu++;
        }
        Serial.println();
        if (WiFi.status() == WL_CONNECTED) {
            WiFi.setSleep(false);         // PENTING: matikan sleep agar stream stabil
            WiFi.setAutoReconnect(true);
            return true;
        }
        WiFi.disconnect(true);
        delay(1000);
    }
    return false;
}

// ---------------------------------------------------------------------
// Background Task: Unggah frame JPEG otomatis ke Railway Cloud
// ---------------------------------------------------------------------
void railwayUploadLoop(void *param) {
    Serial.println("[Cloud] Upload task aktif di Core 1");

    WiFiClientSecure secureClient;
    secureClient.setInsecure(); // Bypass cert check untuk efisiensi kecepatan

    HTTPClient https;
    unsigned long lastLog = 0;
    int successCount = 0;
    int failCount = 0;

    while (true) {
        if (!cloudUploadActive || !railwayUploadUrl || strlen(railwayUploadUrl) < 10) {
            vTaskDelay(2000 / portTICK_PERIOD_MS);
            continue;
        }

        if (WiFi.status() == WL_CONNECTED) {
            camera_fb_t *fb = esp_camera_fb_get();
            if (fb) {
                if (https.begin(secureClient, railwayUploadUrl)) {
                    https.addHeader("Content-Type", "image/jpeg");
                    https.setTimeout(3500);

                    int code = https.POST(fb->buf, fb->len);
                    if (code == 200) {
                        successCount++;
                    } else {
                        failCount++;
                        if (failCount % 10 == 0) {
                            Serial.printf("[Cloud] Upload HTTP %d\n", code);
                        }
                    }
                    https.end();
                } else {
                    failCount++;
                }
                esp_camera_fb_return(fb);
            }

            if (millis() - lastLog >= 10000) {
                lastLog = millis();
                if (successCount > 0 || failCount > 0) {
                    Serial.printf("[Cloud] 10s: %d OK, %d Gagal | Free Heap: %u\n",
                                  successCount, failCount, ESP.getFreeHeap());
                }
                successCount = 0;
                failCount = 0;
            }
        }

        vTaskDelay(uploadIntervalMs / portTICK_PERIOD_MS);
    }
}

// ---------------------------
// Inisialisasi Kamera (logika CameraWebServer)
// ---------------------------
bool initCamera() {
    camera_config_t config;
    config.ledc_channel = LEDC_CHANNEL_0;
    config.ledc_timer   = LEDC_TIMER_0;
    config.pin_d0       = Y2_GPIO_NUM;
    config.pin_d1       = Y3_GPIO_NUM;
    config.pin_d2       = Y4_GPIO_NUM;
    config.pin_d3       = Y5_GPIO_NUM;
    config.pin_d4       = Y6_GPIO_NUM;
    config.pin_d5       = Y7_GPIO_NUM;
    config.pin_d6       = Y8_GPIO_NUM;
    config.pin_d7       = Y9_GPIO_NUM;
    config.pin_xclk     = XCLK_GPIO_NUM;
    config.pin_pclk     = PCLK_GPIO_NUM;
    config.pin_vsync    = VSYNC_GPIO_NUM;
    config.pin_href     = HREF_GPIO_NUM;
    config.pin_sccb_sda = SIOD_GPIO_NUM;
    config.pin_sccb_scl = SIOC_GPIO_NUM;
    config.pin_pwdn     = PWDN_GPIO_NUM;
    config.pin_reset    = RESET_GPIO_NUM;
    config.xclk_freq_hz = 20000000;
    config.frame_size   = FRAMESIZE_UXGA;  // Init besar dulu, nanti diturunkan
    config.pixel_format = PIXFORMAT_JPEG;
    config.grab_mode    = CAMERA_GRAB_WHEN_EMPTY;
    config.fb_location  = CAMERA_FB_IN_PSRAM;
    config.jpeg_quality = 12;
    config.fb_count     = 1;

    // Jika PSRAM ada, pakai kualitas lebih baik & 2 buffer
    if (psramFound()) {
        config.jpeg_quality = 10;
        config.fb_count     = 2;
        config.grab_mode    = CAMERA_GRAB_LATEST;
        Serial.println("[CAM] PSRAM ditemukan, mode 2 buffer");
    } else {
        // Tanpa PSRAM: turunkan resolusi & pakai DRAM
        config.frame_size   = FRAMESIZE_SVGA;
        config.fb_location  = CAMERA_FB_IN_DRAM;
        Serial.println("[CAM] Tanpa PSRAM, mode DRAM");
    }

    esp_err_t err = esp_camera_init(&config);
    if (err != ESP_OK) {
        Serial.printf("[CAM] Init gagal (0x%x)\n", err);
        return false;
    }

    // Turunkan resolusi kerja ke VGA (640x480) – cukup besar untuk face recognition
    sensor_t *s = esp_camera_sensor_get();
    if (s->id.PID == OV3660_PID) {
        s->set_vflip(s, 1);
        s->set_brightness(s, 1);
        s->set_saturation(s, -2);
    }
    s->set_framesize(s, FRAMESIZE_VGA);

    Serial.println("[CAM] Kamera OK (VGA 640x480)");
    return true;
}

// ── Setup ────────────────────────────────────────────────────────────
void setup() {
    Serial.begin(115200);
    Serial.setDebugOutput(true);
    delay(1000);
    Serial.println("\n[BisaGym] ESP32-CAM CameraWebServer");

    // LED flash off
    pinMode(LED_GPIO_NUM, OUTPUT);
    digitalWrite(LED_GPIO_NUM, LOW);

    bool camOk  = initCamera();
    bool wifiOk = connectWiFi();

    if (wifiOk && camOk) {
        if (MDNS.begin("esp32cam")) {
            Serial.println("[mDNS] http://esp32cam.local");
        }
        startWebServer();

        // Mulai background upload ke Railway di Core 1
        xTaskCreatePinnedToCore(
            railwayUploadLoop,
            "railwayUpload",
            8192,
            NULL,
            1,
            &uploadTaskHandle,
            1
        );

        Serial.println("=================================================");
        Serial.printf("  Halaman : http://%s/\n",        WiFi.localIP().toString().c_str());
        Serial.printf("  Stream  : http://%s:81/stream\n", WiFi.localIP().toString().c_str());
        Serial.printf("  Capture : http://%s/capture\n",  WiFi.localIP().toString().c_str());
        Serial.printf("  Status  : http://%s/status\n",   WiFi.localIP().toString().c_str());
        Serial.printf("  Cloud   : %s\n",                 railwayUploadUrl);
        Serial.println("=================================================");
        Serial.println("Kamera online di: https://esp32cam-production-704ea82e.up.railway.app");
        Serial.println("Masukkan URL Cloud di atas ke halaman Absensi BisaGym.");
    } else {
        Serial.printf("[ERROR] WiFi: %s | Kamera: %s\n",
                      wifiOk ? "OK" : "GAGAL", camOk ? "OK" : "GAGAL");
        Serial.println("Cek: (1) IO0 JANGAN terhubung ke GND setelah flash");
        Serial.println("     (2) Kabel pita kamera terpasang dengan benar");
        Serial.println("     (3) SSID & password Wi-Fi benar");
    }
}

// ── Loop ─────────────────────────────────────────────────────────────
void loop() {
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("[WiFi] Terputus, reconnect...");
        WiFi.disconnect();
        WiFi.begin(ssid, password);
        int t = 0;
        while (WiFi.status() != WL_CONNECTED && t < 20) {
            delay(500);
            Serial.print(".");
            t++;
        }
        if (WiFi.status() == WL_CONNECTED) {
            Serial.printf("\n[WiFi] Tersambung kembali: %s\n", WiFi.localIP().toString().c_str());
        }
    }
    delay(10000);
}
