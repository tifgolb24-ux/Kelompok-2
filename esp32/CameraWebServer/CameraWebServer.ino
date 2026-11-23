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
#include <Wire.h>

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

// =====================================================================
// Konfigurasi Pin Periferal Tambahan (BisaGym Smart Kiosk)
// =====================================================================
#define PIN_LED_1          14   // LED 1 (Hijau: Absen Dikenali)
#define PIN_LED_2           2   // LED 2 (Merah: Absen Tidak Dikenali)
#define PIN_BUZZER         12   // Buzzer (1x Berhasil, 3x Gagal) - Ganti pin jika dicolok ke pin lain
#define PIN_SUHU           16   // Sensor Suhu (Data Pin 16)
#define PIN_I2C_SCL        13   // I2C LCD SCL (Pin 13)
#define PIN_I2C_SDA        15   // I2C LCD SDA (Pin 15)
#define PIN_RELAY           4   // Relay Kipas Angin (Pin 4)

// Ambang Batas Suhu Kipas Otomatis
float SUHU_PANAS_THRESHOLD  = 32.0; // Jika suhu >= 32.0 C -> Kipas (Relay) ON
float SUHU_NORMAL_THRESHOLD = 29.0; // Jika suhu <= 29.0 C -> Kipas (Relay) OFF (Histeresis)
#define LCD_I2C_ADDR        0x27    // Alamat I2C LCD (umumnya 0x27 atau 0x3F)

// Level Aktif (Ubah ke LOW jika modul relay/buzzer Anda tipe Active-LOW)
#define RELAY_ACTIVE_LEVEL HIGH // HIGH = Relay Kipas Menyala
#define LED_ACTIVE_LEVEL   HIGH // HIGH = LED Menyala
#define BUZZER_ACTIVE_LEVEL HIGH // HIGH = Buzzer Berbunyi

// Status Periferal
bool relayState   = false; // Status Kipas (Relay Pin 4)
bool led1State    = false; // LED 1 (Pin 14)
bool led2State    = false; // LED 2 (Pin 2)
float suhuSekarang = 28.5; // Nilai suhu terakhir

// Timer feedback absen (matikan LED/kembali standby setelah 3.5 detik)
unsigned long ledFeedbackTurnOffTime = 0;
bool ledFeedbackActive = false;

// ---------------------------------------------------------------------
// LCD 16x2 I2C (SCL Pin 13, SDA Pin 15)
// ---------------------------------------------------------------------
#if __has_include(<LiquidCrystal_I2C.h>)
#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(LCD_I2C_ADDR, 16, 2);
#define HAS_LCD_LIB 1
#else
#define HAS_LCD_LIB 0
#endif

void lcdInit() {
    Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);
#if HAS_LCD_LIB
    lcd.init();
    lcd.backlight();
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("BisaGym Kiosk");
    lcd.setCursor(0, 1);
    lcd.print("Siap Absensi...");
#else
    Serial.println("[LCD] Tips: Pasang library 'LiquidCrystal I2C' via Arduino Library Manager.");
#endif
}

void lcdTampilkan(const char *baris1, const char *baris2 = "") {
    Serial.printf("[LCD] [%s] [%s]\n", baris1, baris2 ? baris2 : "");
#if HAS_LCD_LIB
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(baris1);
    if (baris2 && strlen(baris2) > 0) {
        lcd.setCursor(0, 1);
        lcd.print(baris2);
    }
#endif
}

void lcdResetStandby() {
#if HAS_LCD_LIB
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("BisaGym FaceScan");
    lcd.setCursor(0, 1);
    char buf[17];
    snprintf(buf, sizeof(buf), "%.1fC | FAN:%s", suhuSekarang, relayState ? "ON " : "OFF");
    lcd.print(buf);
#endif
}

// ---------------------------------------------------------------------
// Kontrol Periferal (Relay, LED, Buzzer)
// ---------------------------------------------------------------------
void setRelay(bool on) {
    relayState = on;
    digitalWrite(PIN_RELAY, on ? RELAY_ACTIVE_LEVEL : !RELAY_ACTIVE_LEVEL);
    Serial.printf("[KIPAS] Relay Kipas: %s\n", on ? "AKTIF (MENYALA)" : "NONAKTIF (MATI)");
}

void setLed1(bool on) {
    led1State = on;
    digitalWrite(PIN_LED_1, on ? LED_ACTIVE_LEVEL : !LED_ACTIVE_LEVEL);
}

void setLed2(bool on) {
    led2State = on;
    digitalWrite(PIN_LED_2, on ? LED_ACTIVE_LEVEL : !LED_ACTIVE_LEVEL);
}

// Bunyikan buzzer secara non-blocking via FreeRTOS Task
void bunyikanBuzzer(int kali) {
    xTaskCreate(
        [](void *param) {
            int n = (int)param;
            for (int i = 0; i < n; i++) {
                digitalWrite(PIN_BUZZER, BUZZER_ACTIVE_LEVEL);
                vTaskDelay(200 / portTICK_PERIOD_MS);
                digitalWrite(PIN_BUZZER, !BUZZER_ACTIVE_LEVEL);
                if (i < n - 1) {
                    vTaskDelay(120 / portTICK_PERIOD_MS);
                }
            }
            vTaskDelete(NULL);
        },
        "buzzerTask",
        1536,
        (void*)kali,
        1,
        NULL
    );
}

// ---------------------------------------------------------------------
// Event Absensi (Dikenali & Tidak Dikenali)
// ---------------------------------------------------------------------
void onAbsenBerhasil(const char *nama = "Member") {
    setLed1(true);  // LED 1 (Hijau) Hidup
    setLed2(false); // LED 2 Mati
    bunyikanBuzzer(1); // Buzzer bunyi 1 KALI

    char baris2[17];
    snprintf(baris2, sizeof(baris2), "%-.16s", (nama && strlen(nama) > 0) ? nama : "Selamat Datang");
    lcdTampilkan("Absen Berhasil!", baris2);

    ledFeedbackTurnOffTime = millis() + 3500;
    ledFeedbackActive = true;
    Serial.printf("[ABSEN] DIKENALI: %s -> LED 1 ON & Buzzer 1x\n", nama);
}

void onAbsenGagal() {
    setLed1(false); // LED 1 Mati
    setLed2(true);  // LED 2 (Merah) Hidup
    bunyikanBuzzer(3); // Buzzer bunyi 3 KALI

    lcdTampilkan("Akses Ditolak!", "Wajah Tdk Kenal");

    ledFeedbackTurnOffTime = millis() + 3500;
    ledFeedbackActive = true;
    Serial.println("[ABSEN] TIDAK DIKENALI -> LED 2 ON & Buzzer 3x");
}

// ---------------------------------------------------------------------
// Baca Sensor Suhu & Kontrol Kipas Otomatis
// ---------------------------------------------------------------------
float bacaSuhu() {
    int val = digitalRead(PIN_SUHU);
    // Sensor suhu digital (KY-028 / comparator): HIGH saat panas
    if (val == HIGH) {
        suhuSekarang = 34.0;
    } else {
        if (suhuSekarang > 30.0) suhuSekarang = 28.0;
    }
    return suhuSekarang;
}

void cekSuhuDanKipas() {
    static unsigned long lastCheck = 0;
    if (millis() - lastCheck < 2500) return;
    lastCheck = millis();

    float temp = bacaSuhu();

    // Suhu terdeteksi panas -> Relay hidupkan kipas
    // Suhu kembali normal -> Matikan kipas
    if (temp >= SUHU_PANAS_THRESHOLD && !relayState) {
        setRelay(true);
        Serial.printf("[KIPAS] Suhu PANAS (%.1f C >= %.1f C) -> Kipas ON!\n", temp, SUHU_PANAS_THRESHOLD);
        if (!ledFeedbackActive) lcdResetStandby();
    } else if (temp <= SUHU_NORMAL_THRESHOLD && relayState) {
        setRelay(false);
        Serial.printf("[KIPAS] Suhu NORMAL (%.1f C <= %.1f C) -> Kipas OFF\n", temp, SUHU_NORMAL_THRESHOLD);
        if (!ledFeedbackActive) lcdResetStandby();
    }
}

httpd_handle_t httpServer   = NULL;  // port 80
httpd_handle_t streamServer = NULL;  // port 81

// ---------------------------
// Halaman utama (port 80 /)
// ---------------------------
static esp_err_t index_handler(httpd_req_t *req) {
    const char *html =
        "<!DOCTYPE html><html><head><meta name='viewport' content='width=device-width,initial-scale=1'>"
        "<title>BisaGym ESP32-CAM Smart Kiosk</title>"
        "<style>body{text-align:center;font-family:sans-serif;background:#111;color:#eee;padding:10px}"
        "button{padding:8px 14px;margin:4px;border:none;border-radius:6px;cursor:pointer;font-weight:bold}"
        ".btn-green{background:#10b981;color:#fff}.btn-blue{background:#3b82f6;color:#fff}"
        ".btn-red{background:#ef4444;color:#fff}.btn-dark{background:#374151;color:#eee}</style></head>"
        "<body>"
        "<h2>BisaGym ESP32-CAM Smart Kiosk</h2>"
        "<img id='cam' style='max-width:100%;border-radius:8px'>"
        "<p>Resolusi: "
        "<select onchange='setRes(this.value)'>"
        "<option value='5'>QVGA 320x240</option>"
        "<option value='8' selected>VGA 640x480</option>"
        "<option value='9'>SVGA 800x600</option>"
        "</select></p>"
        "<hr style='border:1px solid #333;margin:15px 0'>"
        "<h3>Simulasi Absensi (Feedback Hardware)</h3>"
        "<p>"
        "<button class='btn-green' onclick=\"fetch('/absen?status=berhasil&name=Member%20Demo')\">Simulasi Absen Dikenali (LED 1 ON + Beep 1x)</button>"
        "<button class='btn-red' onclick=\"fetch('/absen?status=gagal')\">Simulasi Absen Ditolak (LED 2 ON + Beep 3x)</button>"
        "</p>"
        "<h3>Kontrol Suhu & Kipas (Relay Pin 4)</h3>"
        "<p>"
        "<button class='btn-blue' onclick=\"fetch('/relay?state=1')\">Kipas ON</button>"
        "<button class='btn-dark' onclick=\"fetch('/relay?state=0')\">Kipas OFF</button>"
        "<button class='btn-dark' onclick=\"fetch('/suhu?val=35').then(()=>alert('Simulasi Suhu Panas 35C (Kipas akan ON)'))\">Simulasi Panas (35&deg;C)</button>"
        "<button class='btn-dark' onclick=\"fetch('/suhu?val=27').then(()=>alert('Simulasi Suhu Normal 27C (Kipas akan OFF)'))\">Simulasi Normal (27&deg;C)</button>"
        "</p>"
        "<p><a style='color:#6cf' href='/capture' target='_blank'>Ambil Foto</a> | "
        "<a style='color:#6cf' href='/status' target='_blank'>Status JSON</a> | "
        "<a style='color:#a3e635' href='/suhu' target='_blank'>Data Suhu & Kipas</a></p>"
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

    char json[384];
    snprintf(json, sizeof(json),
             "{\"status\":\"ready\",\"ip\":\"%s\","
             "\"psram\":%s,\"frame_ok\":%s,\"frame_bytes\":%u,"
             "\"free_heap\":%u,"
             "\"relay_kipas\":%s,\"led1\":%s,\"led2\":%s,\"suhu\":%.1f,\"suhu_pin\":%d,"
             "\"threshold_panas\":%.1f,\"threshold_normal\":%.1f,"
             "\"stream_url\":\"http://%s:81/stream\","
             "\"capture_url\":\"http://%s/capture\"}",
             WiFi.localIP().toString().c_str(),
             psramFound() ? "true" : "false",
             frameOk ? "true" : "false",
             (unsigned int)frameBytes,
             ESP.getFreeHeap(),
             relayState ? "true" : "false",
             led1State ? "true" : "false",
             led2State ? "true" : "false",
             suhuSekarang,
             PIN_SUHU,
             SUHU_PANAS_THRESHOLD,
             SUHU_NORMAL_THRESHOLD,
             WiFi.localIP().toString().c_str(),
             WiFi.localIP().toString().c_str());
    return httpd_resp_send(req, json, strlen(json));
}

// ---------------------------
// Handler Notifikasi Absensi: /absen?status=berhasil|gagal|1|0&name=Nama
// ---------------------------
static esp_err_t absen_handler(httpd_req_t *req) {
    char query[128], statusVal[16], nameVal[32];
    nameVal[0] = '\0';

    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK) {
        httpd_query_key_value(query, "name", nameVal, sizeof(nameVal));

        if (httpd_query_key_value(query, "status", statusVal, sizeof(statusVal)) == ESP_OK) {
            if (strcmp(statusVal, "berhasil") == 0 || strcmp(statusVal, "1") == 0 ||
                strcmp(statusVal, "allow") == 0 || strcmp(statusVal, "ALLOW") == 0) {
                onAbsenBerhasil(nameVal[0] ? nameVal : "Member");
            } else {
                onAbsenGagal();
            }
        }
    }

    char resp[160];
    snprintf(resp, sizeof(resp),
             "{\"status\":\"ok\",\"led1\":%s,\"led2\":%s,\"relay_kipas\":%s}",
             led1State ? "true" : "false", led2State ? "true" : "false", relayState ? "true" : "false");
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, resp, strlen(resp));
}

// ---------------------------
// Handler Relay (Kipas): /relay?state=1 | /relay?state=0
// ---------------------------
static esp_err_t relay_handler(httpd_req_t *req) {
    char query[64], val[16];
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK) {
        if (httpd_query_key_value(query, "state", val, sizeof(val)) == ESP_OK) {
            int st = atoi(val);
            setRelay(st == 1);
        }
    }
    char resp[128];
    snprintf(resp, sizeof(resp), "{\"status\":\"ok\",\"relay_kipas\":%s}", relayState ? "true" : "false");
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, resp, strlen(resp));
}

// ---------------------------
// Handler LED: /led?id=1|2&state=1|0
// ---------------------------
static esp_err_t led_handler(httpd_req_t *req) {
    char query[64], idVal[8], stateVal[8];
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK) {
        if (httpd_query_key_value(query, "id", idVal, sizeof(idVal)) == ESP_OK &&
            httpd_query_key_value(query, "state", stateVal, sizeof(stateVal)) == ESP_OK) {
            int id = atoi(idVal);
            int st = atoi(stateVal);
            if (id == 1) setLed1(st == 1);
            else if (id == 2) setLed2(st == 1);
        }
    }
    char resp[128];
    snprintf(resp, sizeof(resp), "{\"status\":\"ok\",\"led1\":%s,\"led2\":%s}",
             led1State ? "true" : "false", led2State ? "true" : "false");
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, resp, strlen(resp));
}

// ---------------------------
// Handler Baca / Set Suhu: /suhu (atau /suhu?val=34)
// ---------------------------
static esp_err_t suhu_handler(httpd_req_t *req) {
    char query[64], val[16];
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK) {
        if (httpd_query_key_value(query, "val", val, sizeof(val)) == ESP_OK) {
            suhuSekarang = atof(val);
            cekSuhuDanKipas();
        }
    }

    char resp[192];
    snprintf(resp, sizeof(resp),
             "{\"status\":\"ok\",\"suhu\":%.1f,\"kipas\":%s,\"threshold_panas\":%.1f,\"threshold_normal\":%.1f,\"pin\":%d}",
             suhuSekarang, relayState ? "true" : "false", SUHU_PANAS_THRESHOLD, SUHU_NORMAL_THRESHOLD, PIN_SUHU);
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, resp, strlen(resp));
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
    config.max_uri_handlers = 16;
    config.stack_size = 8192;

    // Port 80: halaman utama, capture, size, status, stream, dan hardware kontrol
    config.server_port = 80;
    if (httpd_start(&httpServer, &config) == ESP_OK) {
        httpd_uri_t indexUri    = { "/",        HTTP_GET, index_handler,   NULL };
        httpd_uri_t captureUri  = { "/capture", HTTP_GET, capture_handler, NULL };
        httpd_uri_t sizeUri     = { "/size",    HTTP_GET, size_handler,    NULL };
        httpd_uri_t statusUri   = { "/status",  HTTP_GET, status_handler,  NULL };
        httpd_uri_t streamUri80 = { "/stream",  HTTP_GET, stream_handler,  NULL };
        httpd_uri_t relayUri    = { "/relay",   HTTP_GET, relay_handler,   NULL };
        httpd_uri_t ledUri      = { "/led",     HTTP_GET, led_handler,     NULL };
        httpd_uri_t suhuUri     = { "/suhu",    HTTP_GET, suhu_handler,    NULL };
        httpd_uri_t absenUri    = { "/absen",   HTTP_GET, absen_handler,   NULL };

        httpd_register_uri_handler(httpServer, &indexUri);
        httpd_register_uri_handler(httpServer, &captureUri);
        httpd_register_uri_handler(httpServer, &sizeUri);
        httpd_register_uri_handler(httpServer, &statusUri);
        httpd_register_uri_handler(httpServer, &streamUri80);
        httpd_register_uri_handler(httpServer, &relayUri);
        httpd_register_uri_handler(httpServer, &ledUri);
        httpd_register_uri_handler(httpServer, &suhuUri);
        httpd_register_uri_handler(httpServer, &absenUri);
        Serial.println("[HTTP] Web server (port 80) aktif (Kamera & Kontrol Hardware)");
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

    // Inisialisasi Pin Periferal Tambahan
    pinMode(PIN_RELAY, OUTPUT);
    digitalWrite(PIN_RELAY, !RELAY_ACTIVE_LEVEL); // Matikan relay kipas saat startup

    pinMode(PIN_LED_1, OUTPUT);
    digitalWrite(PIN_LED_1, !LED_ACTIVE_LEVEL);   // Matikan LED 1 (Hijau)

    pinMode(PIN_LED_2, OUTPUT);
    digitalWrite(PIN_LED_2, !LED_ACTIVE_LEVEL);   // Matikan LED 2 (Merah)

    pinMode(PIN_BUZZER, OUTPUT);
    digitalWrite(PIN_BUZZER, !BUZZER_ACTIVE_LEVEL); // Matikan Buzzer

    pinMode(PIN_SUHU, INPUT);                     // Inisialisasi Pin Suhu

    // Inisialisasi Bus I2C & Layar LCD 16x2
    lcdInit();

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
unsigned long lastWifiCheck = 0;
unsigned long lastLcdUpdate = 0;

void loop() {
    // 1. Cek timer feedback LED & LCD (reset ke standby setelah 3.5 detik)
    if (ledFeedbackActive && millis() >= ledFeedbackTurnOffTime) {
        setLed1(false);
        setLed2(false);
        ledFeedbackActive = false;
        lcdResetStandby();
    }

    // 2. Cek sensor suhu dan kontrol otomatis Kipas (Relay Pin 4)
    cekSuhuDanKipas();

    // 3. Update status LCD standby secara berkala (setiap 4 detik saat standby)
    if (!ledFeedbackActive && millis() - lastLcdUpdate >= 4000) {
        lastLcdUpdate = millis();
        lcdResetStandby();
    }

    // 4. Baca perintah dari Serial USB (misal dari browser via Web Serial)
    if (Serial.available()) {
        String cmd = Serial.readStringUntil('\n');
        cmd.trim();
        if (cmd == "OK" || cmd == "ALLOW" || cmd == "BERHASIL") {
            onAbsenBerhasil("Member");
        } else if (cmd == "UNKNOWN" || cmd == "DENY" || cmd == "GAGAL") {
            onAbsenGagal();
        } else if (cmd == "FAN_ON") {
            setRelay(true);
        } else if (cmd == "FAN_OFF") {
            setRelay(false);
        }
    }

    // 5. Cek koneksi WiFi setiap 10 detik secara non-blocking
    if (millis() - lastWifiCheck >= 10000) {
        lastWifiCheck = millis();
        if (WiFi.status() != WL_CONNECTED) {
            Serial.println("[WiFi] Terputus, mencoba reconnect...");
            WiFi.disconnect();
            WiFi.begin(ssid, password);
        }
    }

    delay(20); // Delay kecil agar CPU stabil dan tidak memicu watchdog
}
