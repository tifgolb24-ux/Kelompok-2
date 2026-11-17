/**
 * BisaGym — ESP32-CAM Stream Server (High-Compatibility Edition)
 * =====================================================================
 * Endpoint yang disediakan:
 *   GET http://<ip>:81/stream   → MJPEG live stream (untuk preview di web)
 *   GET http://<ip>/capture     → Satu frame JPEG (untuk AI biometrik)
 *   GET http://<ip>/status      → Status sistem, PSRAM, frame test (JSON)
 *
 * Board yang didukung: AI-Thinker ESP32-CAM & Klon OV2640
 * =====================================================================
 */

#include "esp_camera.h"
#include <WiFi.h>
#include "esp_timer.h"
#include "img_converters.h"
#include "Arduino.h"
#include "esp_http_server.h"

// ── Wi-Fi ───────────────────────────────────────────────────────────
const char* WIFI_SSID     = "REDMI Note 15 5G";    // <-- SSID Hotspot Anda
const char* WIFI_PASSWORD = "mimpiIBADAH";  // <-- Masukkan password hotspot Anda di sini

// ── Pinout AI-Thinker ESP32-CAM ─────────────────────────────────────
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

// ── Boundary MJPEG ───────────────────────────────────────────────────
#define PART_BOUNDARY "123456789000000000000987654321"
static const char* STREAM_CONTENT_TYPE = "multipart/x-mixed-replace;boundary=" PART_BOUNDARY;
static const char* STREAM_BOUNDARY     = "\r\n--" PART_BOUNDARY "\r\n";
static const char* STREAM_PART         = "Content-Type: image/jpeg\r\nContent-Length: %u\r\n\r\n";

httpd_handle_t stream_httpd  = NULL;
httpd_handle_t capture_httpd = NULL;

bool cameraReady = false;

// ── Handler /stream (port 81) ────────────────────────────────────────
static esp_err_t stream_handler(httpd_req_t* req) {
    esp_err_t res = ESP_OK;
    char part_buf[64];
    int failures = 0;

    res = httpd_resp_set_type(req, STREAM_CONTENT_TYPE);
    if (res != ESP_OK) return res;

    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    httpd_resp_set_hdr(req, "X-Framerate", "15");

    while (true) {
        camera_fb_t* fb = esp_camera_fb_get();
        if (!fb) {
            failures++;
            if (failures % 10 == 0) {
                Serial.printf("[CAM] Frame stream belum siap (%d timeout)...\n", failures);
            }
            if (failures > 30) {
                Serial.println("[CAM] Stream dihentikan karena sensor tidak mengirim frame.");
                res = ESP_FAIL;
                break;
            }
            delay(100);
            continue;
        }

        failures = 0;
        size_t hlen = snprintf(part_buf, sizeof(part_buf), STREAM_PART, fb->len);

        res = httpd_resp_send_chunk(req, STREAM_BOUNDARY, strlen(STREAM_BOUNDARY));
        if (res == ESP_OK) {
            res = httpd_resp_send_chunk(req, part_buf, hlen);
        }
        if (res == ESP_OK) {
            res = httpd_resp_send_chunk(req, (const char*)fb->buf, fb->len);
        }

        esp_camera_fb_return(fb);

        if (res != ESP_OK) {
            break;
        }

        delay(30);
    }
    return res;
}

// ── Handler /capture (port 80) ───────────────────────────────────────
static esp_err_t capture_handler(httpd_req_t* req) {
    camera_fb_t* fb = NULL;

    for (int retry = 0; retry < 3; retry++) {
        fb = esp_camera_fb_get();
        if (fb) break;
        delay(100);
    }

    if (!fb) {
        Serial.println("[CAM] Gagal mengambil frame untuk /capture!");
        httpd_resp_set_type(req, "text/plain");
        httpd_resp_set_status(req, "500 Internal Server Error");
        httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
        const char* errMsg = "Gagal mengambil frame dari sensor OV2640. Periksa kabel pita & daya 5V.";
        return httpd_resp_send(req, errMsg, strlen(errMsg));
    }

    httpd_resp_set_type(req, "image/jpeg");
    httpd_resp_set_hdr(req, "Content-Disposition", "inline; filename=capture.jpg");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    httpd_resp_set_hdr(req, "Cache-Control", "no-cache, no-store, must-revalidate");

    esp_err_t res = httpd_resp_send(req, (const char*)fb->buf, fb->len);
    esp_camera_fb_return(fb);
    return res;
}

// ── Handler /status (port 80) ────────────────────────────────────────
static esp_err_t status_handler(httpd_req_t* req) {
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");

    // Tes ambil 1 frame singkat
    camera_fb_t* testFb = esp_camera_fb_get();
    bool frameOk = (testFb != NULL);
    size_t frameBytes = frameOk ? testFb->len : 0;
    if (testFb) {
        esp_camera_fb_return(testFb);
    }

    char json[200];
    snprintf(json, sizeof(json),
             "{\"status\":\"ready\",\"ip\":\"%s\",\"psram\":%s,\"camera\":%s,\"frame_ok\":%s,\"frame_bytes\":%u,\"free_heap\":%u}",
             WiFi.localIP().toString().c_str(),
             psramFound() ? "true" : "false",
             cameraReady ? "true" : "false",
             frameOk ? "true" : "false",
             (unsigned int)frameBytes,
             ESP.getFreeHeap());
    return httpd_resp_send(req, json, strlen(json));
}

// ── Inisialisasi HTTP Server ─────────────────────────────────────────
void startServers() {
    // --- Server port 80 (/capture, /status) ---
    httpd_config_t config_80 = HTTPD_DEFAULT_CONFIG();
    config_80.server_port    = 80;
    config_80.ctrl_port      = 32768;
    config_80.uri_match_fn   = httpd_uri_match_wildcard;

    if (httpd_start(&capture_httpd, &config_80) == ESP_OK) {
        httpd_uri_t capture_uri = {
            .uri      = "/capture*",
            .method   = HTTP_GET,
            .handler  = capture_handler,
            .user_ctx = NULL
        };
        httpd_register_uri_handler(capture_httpd, &capture_uri);

        httpd_uri_t status_uri = {
            .uri      = "/status*",
            .method   = HTTP_GET,
            .handler  = status_handler,
            .user_ctx = NULL
        };
        httpd_register_uri_handler(capture_httpd, &status_uri);

        Serial.println("[HTTP] Server capture aktif di port 80");
    }

    // --- Server port 81 (/stream) ---
    httpd_config_t config_81 = HTTPD_DEFAULT_CONFIG();
    config_81.server_port    = 81;
    config_81.ctrl_port      = 32769;
    config_81.uri_match_fn   = httpd_uri_match_wildcard;

    if (httpd_start(&stream_httpd, &config_81) == ESP_OK) {
        httpd_uri_t stream_uri = {
            .uri      = "/stream*",
            .method   = HTTP_GET,
            .handler  = stream_handler,
            .user_ctx = NULL
        };
        httpd_register_uri_handler(stream_httpd, &stream_uri);

        Serial.println("[HTTP] Server stream aktif di port 81");
    }
}

// ── Inisialisasi Kamera ──────────────────────────────────────────────
bool initCamera() {
    // Reset power pin PWDN (GPIO 32)
    pinMode(PWDN_GPIO_NUM, OUTPUT);
    digitalWrite(PWDN_GPIO_NUM, HIGH);
    delay(20);
    digitalWrite(PWDN_GPIO_NUM, LOW);
    delay(50);

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
    config.pixel_format = PIXFORMAT_JPEG;
    config.frame_size   = FRAMESIZE_UXGA; // Init pada resolusi maksimal sesuai standar CameraWebServer
    config.jpeg_quality = 10;
    config.fb_count     = 2;
    config.grab_mode    = CAMERA_GRAB_WHEN_EMPTY; // Mencegah deadlock driver
    config.fb_location  = CAMERA_FB_IN_PSRAM;

    if (!psramFound()) {
        Serial.println("[CAM] PERINGATAN: PSRAM tidak terdeteksi! Menggunakan DRAM");
        config.frame_size   = FRAMESIZE_SVGA;
        config.jpeg_quality = 12;
        config.fb_count     = 1;
        config.fb_location  = CAMERA_FB_IN_DRAM;
    }

    esp_err_t err = esp_camera_init(&config);
    if (err != ESP_OK) {
        Serial.printf("[CAM] Init gagal (0x%x). Coba clock 10MHz...\n", err);
        config.xclk_freq_hz = 10000000;
        config.frame_size   = FRAMESIZE_SVGA;
        config.fb_count     = 1;
        err = esp_camera_init(&config);
        if (err != ESP_OK) {
            Serial.printf("[CAM] Inisialisasi kamera GAGAL: 0x%x\n", err);
            return false;
        }
    }

    sensor_t* s = esp_camera_sensor_get();
    if (s) {
        // Turunkan resolusi ke VGA (640x480) setelah init UXGA berhasil
        s->set_framesize(s, FRAMESIZE_VGA);
        s->set_brightness(s, 0);
        s->set_contrast(s, 0);
        s->set_saturation(s, 0);
        s->set_whitebal(s, 1);
        s->set_awb_gain(s, 1);
        s->set_wb_mode(s, 0);
        s->set_exposure_ctrl(s, 1);
        s->set_aec2(s, 0);
        s->set_ae_level(s, 0);
        s->set_gain_ctrl(s, 1);
        s->set_agc_gain(s, 0);
        s->set_gainceiling(s, (gainceiling_t)6);
        s->set_bpc(s, 0);
        s->set_wpc(s, 1);
        s->set_raw_gma(s, 1);
        s->set_lenc(s, 1);
        s->set_hmirror(s, 0);
        s->set_vflip(s, 0);
        s->set_dcw(s, 1);
        s->set_colorbar(s, 0);
    }

    Serial.println("[CAM] Kamera berhasil diinisialisasi");

    // Lakukan Warmup frame (3x) untuk menguji apakah piksel kamera benar-benar terbaca
    Serial.println("[CAM] Menguji pengambilan frame pertama...");
    delay(300);
    for (int i = 1; i <= 3; i++) {
        camera_fb_t* fb = esp_camera_fb_get();
        if (fb) {
            Serial.printf("[CAM] Test frame %d BERHASIL! Ukuran: %u bytes\n", i, fb->len);
            esp_camera_fb_return(fb);
            break;
        } else {
            Serial.printf("[CAM] Test frame %d timeout (belum ada data)...\n", i);
            delay(200);
        }
    }

    return true;
}

// ── Setup ────────────────────────────────────────────────────────────
void setup() {
    Serial.begin(115200);
    Serial.setDebugOutput(false);
    Serial.println("\n[BisaGym] ESP32-CAM Stream Server");

    cameraReady = initCamera();

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.printf("[WiFi] Menghubungkan ke %s", WIFI_SSID);

    uint32_t startMs = millis();
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
        if (millis() - startMs > 30000) {
            Serial.println("\n[WiFi] TIMEOUT: Gagal terhubung ke Wi-Fi.");
            return;
        }
    }
    Serial.println();
    Serial.print("[WiFi] Terhubung! IP: ");
    Serial.println(WiFi.localIP());

    startServers();

    Serial.println("=================================================");
    Serial.printf("  Stream  : http://%s:81/stream\n",  WiFi.localIP().toString().c_str());
    Serial.printf("  Capture : http://%s/capture\n",    WiFi.localIP().toString().c_str());
    Serial.printf("  Status  : http://%s/status\n",     WiFi.localIP().toString().c_str());
    Serial.printf("  PSRAM   : %s\n", psramFound() ? "AKTIF" : "NONAKTIF");
    Serial.println("=================================================");
}

// ── Loop ─────────────────────────────────────────────────────────────
void loop() {
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("[WiFi] Koneksi terputus, mencoba reconnect...");
        WiFi.reconnect();
        uint32_t t = millis();
        while (WiFi.status() != WL_CONNECTED && millis() - t < 10000) {
            delay(500);
            Serial.print(".");
        }
        if (WiFi.status() == WL_CONNECTED) {
            Serial.print("\n[WiFi] Tersambung kembali: ");
            Serial.println(WiFi.localIP());
        }
    }
    delay(5000);
}
