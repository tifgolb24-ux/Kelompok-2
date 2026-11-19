/**
 * BisaGym — ESP32-CAM ke Railway Cloud Gateway
 * =====================================================================
 * ESP32-CAM ini:
 * 1. Menghubungkan ke Wi-Fi.
 * 2. Mengunggah (POST) frame JPEG secara otomatis ke server Railway kamu.
 * 3. Tetap menjalankan web server lokal (port 80 & 81) untuk preview lokal.
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

// =====================================================================
// 1. PENGATURAN WI-FI & RAILWAY (GANTI SESUAI DOMAIN RAILWAY KAMU)
// =====================================================================
const char *ssid     = "REDMI Note 15 5G";
const char *password = "mimpiIBADAH";

// Domain Railway aktif:
const char *railwayUploadUrl = "https://esp32cam-production-704ea82e.up.railway.app/upload";

// Delay antar upload ke cloud (milidetik). 150-300ms menghasilkan 3-6 FPS yang halus & hemat kuota
const int uploadIntervalMs = 200;

// =====================================================================
// 2. PIN KAMERA AI-THINKER ESP32-CAM
// =====================================================================
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
#define LED_GPIO_NUM       4

httpd_handle_t httpServer   = NULL;
httpd_handle_t streamServer = NULL;
TaskHandle_t uploadTaskHandle = NULL;
bool cloudUploadActive = true;

// ---------------------------
// Handler HTTP Lokal (Port 80)
// ---------------------------
static esp_err_t capture_handler(httpd_req_t *req) {
    camera_fb_t *fb = esp_camera_fb_get();
    if (!fb) {
        httpd_resp_send_500(req);
        return ESP_FAIL;
    }
    httpd_resp_set_type(req, "image/jpeg");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    esp_err_t res = httpd_resp_send(req, (const char *)fb->buf, fb->len);
    esp_camera_fb_return(fb);
    return res;
}

static esp_err_t status_handler(httpd_req_t *req) {
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    char json[256];
    snprintf(json, sizeof(json),
             "{\"status\":\"ready\",\"ip\":\"%s\",\"cloud_url\":\"%s\",\"cloud_active\":%s}",
             WiFi.localIP().toString().c_str(), railwayUploadUrl, cloudUploadActive ? "true" : "false");
    return httpd_resp_send(req, json, strlen(json));
}

// ---------------------------
// Streaming MJPEG Lokal
// ---------------------------
static esp_err_t stream_handler(httpd_req_t *req) {
    esp_err_t res = httpd_resp_set_type(req, "multipart/x-mixed-replace;boundary=frame");
    if (res != ESP_OK) return res;
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");

    char partBuf[80];
    while (true) {
        camera_fb_t *fb = esp_camera_fb_get();
        if (!fb) {
            vTaskDelay(100 / portTICK_PERIOD_MS);
            continue;
        }
        res = httpd_resp_send_chunk(req, "\r\n--frame\r\n", 12);
        if (res == ESP_OK) {
            size_t hlen = snprintf(partBuf, sizeof(partBuf),
                                   "Content-Type: image/jpeg\r\nContent-Length: %u\r\n\r\n", (unsigned)fb->len);
            res = httpd_resp_send_chunk(req, partBuf, hlen);
        }
        if (res == ESP_OK) {
            res = httpd_resp_send_chunk(req, (const char *)fb->buf, fb->len);
        }
        esp_camera_fb_return(fb);
        if (res != ESP_OK) break;
        vTaskDelay(30 / portTICK_PERIOD_MS);
    }
    return res;
}

void startWebServer() {
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();
    config.max_uri_handlers = 8;
    config.server_port = 80;
    if (httpd_start(&httpServer, &config) == ESP_OK) {
        httpd_uri_t captureUri = { "/capture", HTTP_GET, capture_handler, NULL };
        httpd_uri_t statusUri  = { "/status",  HTTP_GET, status_handler,  NULL };
        httpd_uri_t streamUri  = { "/stream",  HTTP_GET, stream_handler,  NULL };
        httpd_register_uri_handler(httpServer, &captureUri);
        httpd_register_uri_handler(httpServer, &statusUri);
        httpd_register_uri_handler(httpServer, &streamUri);
    }

    config.server_port = 81;
    config.ctrl_port   = 32769;
    if (httpd_start(&streamServer, &config) == ESP_OK) {
        httpd_uri_t streamUri81 = { "/stream", HTTP_GET, stream_handler, NULL };
        httpd_register_uri_handler(streamServer, &streamUri81);
    }
}

// =====================================================================
// 3. BACKGROUND TASK: PUSH FRAME KE RAILWAY CLOUD
// =====================================================================
void railwayUploadLoop(void *param) {
    Serial.println("[Cloud] Background Upload Task aktif di Core 1");

    WiFiClientSecure secureClient;
    secureClient.setInsecure(); // Skip certificate validation for fast connection

    HTTPClient https;
    unsigned long lastLog = 0;
    int successCount = 0;
    int failCount = 0;

    while (true) {
        if (!cloudUploadActive || strstr(railwayUploadUrl, "GANTI-DENGAN-DOMAIN") != NULL) {
            // URL belum diganti, istirahat 3 detik
            vTaskDelay(3000 / portTICK_PERIOD_MS);
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
                            Serial.printf("[Cloud] Upload gagal: HTTP %d\n", code);
                        }
                    }
                    https.end();
                } else {
                    failCount++;
                }
                esp_camera_fb_return(fb);
            }

            // Log tiap 10 detik
            if (millis() - lastLog >= 10000) {
                lastLog = millis();
                Serial.printf("[Cloud] Statistik 10s: %d OK, %d Gagal | Free Heap: %u\n",
                              successCount, failCount, ESP.getFreeHeap());
                successCount = 0;
                failCount = 0;
            }
        }

        vTaskDelay(uploadIntervalMs / portTICK_PERIOD_MS);
    }
}

// =====================================================================
// 4. INISIALISASI KAMERA & WI-FI
// =====================================================================
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
    config.pixel_format = PIXFORMAT_JPEG;

    if (psramFound()) {
        config.frame_size   = FRAMESIZE_VGA; // 640x480
        config.jpeg_quality = 12;
        config.fb_count     = 2;
        config.grab_mode    = CAMERA_GRAB_LATEST;
        Serial.println("[CAM] PSRAM ditemukan (mode 2 buffer VGA)");
    } else {
        config.frame_size   = FRAMESIZE_QVGA; // 320x240
        config.jpeg_quality = 15;
        config.fb_count     = 1;
        config.fb_location  = CAMERA_FB_IN_DRAM;
        Serial.println("[CAM] Tanpa PSRAM (mode DRAM QVGA)");
    }

    esp_err_t err = esp_camera_init(&config);
    if (err != ESP_OK) {
        Serial.printf("[CAM] Init gagal: 0x%x\n", err);
        return false;
    }

    sensor_t *s = esp_camera_sensor_get();
    if (s) {
        s->set_framesize(s, FRAMESIZE_VGA);
    }
    return true;
}

void setup() {
    Serial.begin(115200);
    delay(1000);
    Serial.println("\n=================================================");
    Serial.println("  BisaGym ESP32-CAM -> Railway Cloud Gateway");
    Serial.println("=================================================");

    pinMode(LED_GPIO_NUM, OUTPUT);
    digitalWrite(LED_GPIO_NUM, LOW);

    if (!initCamera()) {
        Serial.println("[ERROR] Kamera gagal diinisialisasi!");
        return;
    }

    Serial.printf("[WiFi] Menghubungkan ke %s ", ssid);
    WiFi.begin(ssid, password);
    int attempts = 0;
    while (WiFi.status() != WL_CONNECTED && attempts < 25) {
        delay(500);
        Serial.print(".");
        attempts++;
    }

    if (WiFi.status() == WL_CONNECTED) {
        Serial.printf("\n[WiFi] Terhubung! IP: %s\n", WiFi.localIP().toString().c_str());
        startWebServer();

        // Jalankan background task upload ke Railway di Core 1
        xTaskCreatePinnedToCore(
            railwayUploadLoop,
            "railwayUpload",
            8192,
            NULL,
            1,
            &uploadTaskHandle,
            1
        );

        Serial.println("-------------------------------------------------");
        Serial.printf("  Lokal Capture : http://%s/capture\n", WiFi.localIP().toString().c_str());
        Serial.printf("  Lokal Stream  : http://%s:81/stream\n", WiFi.localIP().toString().c_str());
        Serial.printf("  Target Cloud  : %s\n", railwayUploadUrl);
        Serial.println("-------------------------------------------------");
    } else {
        Serial.println("\n[WiFi] Gagal terhubung ke Wi-Fi. Periksa SSID/Password.");
    }
}

void loop() {
    if (WiFi.status() != WL_CONNECTED) {
        WiFi.reconnect();
        delay(5000);
    }
    delay(1000);
}
