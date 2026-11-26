/**
 * BisaGym — ESP32-CAM Smart Kiosk (Mode Wi-Fi Lokal)
 * =====================================================================
 * Sketch ini dibuat khusus untuk Kiosk Absensi Gym yang berdiri sendiri
 * TANPA kabel USB ke laptop dan TANPA server Railway.
 *
 * Semua komunikasi lewat Wi-Fi lokal (Router Gym):
 *   - Livestream kamera langsung ke browser laptop kasir
 *   - Buzzer & LED dikontrol lewat HTTP dari website BisaGym
 *   - Sensor suhu & kipas bekerja otomatis mandiri
 *   - LCD menampilkan status kiosk tanpa harus buka Serial Monitor
 *
 * Hardware:
 *   Board  : AI-Thinker ESP32-CAM
 *   Sensor : OV2640
 *   Daya   : Adaptor / Charger HP 5V (1A-2A) ke pin 5V & GND
 *
 * Endpoint HTTP (port 80):
 *   GET /              → Dashboard kontrol + preview kamera
 *   GET /capture       → Satu frame JPEG (untuk AI biometrik)
 *   GET /status        → Status JSON (tes koneksi dari web)
 *   GET /size?v=<N>    → Ganti resolusi kamera
 *   GET /absen?status=berhasil&name=Budi  → Trigger LED Hijau + Beep 1x
 *   GET /absen?status=gagal               → Trigger LED Merah + Beep 3x
 *   GET /relay?state=1 → Kipas ON manual
 *   GET /relay?state=0 → Kipas OFF manual
 *   GET /suhu          → Baca suhu & status kipas (JSON)
 *   GET /led?n=1&s=1   → Kontrol LED manual
 *
 * Endpoint MJPEG Stream (port 81):
 *   GET /stream        → MJPEG live stream (preview wajah real-time)
 *
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
#include <Preferences.h>

// =====================================================================
//  PENGATURAN CLOUD RAILWAY & WEBSITE (fitfacely.com)
// =====================================================================
const char* railwayUploadUrl = "https://esp32cam-production-704ea82e.up.railway.app/upload";
const char* feedbackUrl      = "https://fitfacely.com/api/kiosk-feedback";
const int   uploadIntervalMs = 400;   // Upload frame ke Railway tiap 400ms (stabil)
const int   feedbackPollMs   = 1200;  // Cek sinyal Buzzer/LED dari website tiap 1.2 detik
TaskHandle_t cloudTaskHandle = NULL;
String lastFeedbackId        = "";

// =====================================================================
//  PENGATURAN WI-FI (Daftar Multi-SSID — Otomatis Pilih Yang Tersedia)
// =====================================================================
// Tambahkan Wi-Fi gym / rumah / hotspot Anda di bawah ini.
// ESP32 akan mencoba satu per satu sampai berhasil tersambung.

struct WiFiEntry {
    const char* ssid;
    const char* password;
};

WiFiEntry wifiList[] = {
    { "TECNO POVA 7 5G",  "11111111"   },   // Wi-Fi 1: Hotspot HP (Cadangan)
    { "WiFi_Gym",          "passwordgym" },  // Wi-Fi 2: Router Gym (Ganti sesuai gym)
    // Tambahkan Wi-Fi lain di sini jika perlu:
    // { "NamaWiFi_Lain",  "passwordnya" },
};
const int wifiCount = sizeof(wifiList) / sizeof(wifiList[0]);

// =====================================================================
//  PIN KAMERA AI-THINKER ESP32-CAM (JANGAN DIUBAH)
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

// =====================================================================
//  PIN PERIFERAL KIOSK (Buzzer, LED, Relay, Sensor Suhu, LCD)
// =====================================================================
// PERINGATAN: GPIO 16 JANGAN DIPAKAI — Terhubung ke PSRAM CS!
#define PIN_LED_HIJAU      14   // LED 1 (Hijau): Absen Berhasil / Dikenali
#define PIN_LED_MERAH       2   // LED 2 (Merah): Absen Gagal / Ditolak
#define PIN_BUZZER         12   // Buzzer (1x Berhasil, 3x Gagal)
#define PIN_RELAY           4   // Relay Kipas Angin
#define PIN_SUHU            3   // Sensor Suhu Digital (GPIO 3 = Pin RX)
#define PIN_I2C_SDA        15   // LCD I2C SDA
#define PIN_I2C_SCL        13   // LCD I2C SCL

// Level aktif (Ubah ke LOW jika modul Anda tipe Active-LOW)
#define RELAY_ON    HIGH
#define RELAY_OFF   LOW
#define LED_ON      HIGH
#define LED_OFF     LOW
#define BUZZER_ON   HIGH
#define BUZZER_OFF  LOW

// =====================================================================
//  PENGATURAN SUHU & KIPAS OTOMATIS
// =====================================================================
#define SUHU_PANAS   32.0   // Suhu >= 32°C → Kipas ON
#define SUHU_NORMAL  29.0   // Suhu <= 29°C → Kipas OFF
#define LCD_ADDR     0x27   // Alamat I2C LCD (umumnya 0x27 atau 0x3F)

// =====================================================================
//  STATUS GLOBAL
// =====================================================================
bool relayState    = false;
bool led1State     = false;
bool led2State     = false;
float suhuSekarang = 25.0;
String wifiSSID    = "";

// Timer feedback absen (matikan LED setelah 3.5 detik)
unsigned long feedbackEndTime = 0;
bool feedbackActive = false;

// Timer cek suhu
unsigned long lastSuhuCheck = 0;

// Timer LCD refresh
unsigned long lastLcdRefresh = 0;

// Timer WiFi reconnect
unsigned long lastWifiCheck = 0;

httpd_handle_t httpServer   = NULL;  // port 80
httpd_handle_t streamServer = NULL;  // port 81

// =====================================================================
//  LCD 16x2 I2C (Opsional — otomatis deteksi library)
// =====================================================================
#if __has_include(<LiquidCrystal_I2C.h>)
    #include <LiquidCrystal_I2C.h>
    LiquidCrystal_I2C lcd(LCD_ADDR, 16, 2);
    #define HAS_LCD 1
#else
    #define HAS_LCD 0
#endif

void lcdInit() {
#if HAS_LCD
    Wire.begin(PIN_I2C_SDA, PIN_I2C_SCL);
    lcd.init();
    lcd.backlight();
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("BisaGym Kiosk");
    lcd.setCursor(0, 1);
    lcd.print("Menyalakan...");
#endif
}

void lcdTampil(const char* baris1, const char* baris2 = "") {
#if HAS_LCD
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(baris1);
    if (baris2 && strlen(baris2) > 0) {
        lcd.setCursor(0, 1);
        lcd.print(baris2);
    }
#endif
}

void lcdStandby() {
#if HAS_LCD
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("BisaGym FaceScan");
    lcd.setCursor(0, 1);
    char buf[17];
    snprintf(buf, sizeof(buf), "%.0fC|Fan:%s", suhuSekarang, relayState ? "ON " : "OFF");
    lcd.print(buf);
#endif
}

void lcdTampilIP(const char* ip) {
#if HAS_LCD
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Kiosk Siap!");
    lcd.setCursor(0, 1);
    // Potong IP agar muat di 16 karakter
    char buf[17];
    snprintf(buf, sizeof(buf), "%-16.16s", ip);
    lcd.print(buf);
#endif
}

void lcdWifiGagal() {
#if HAS_LCD
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("WiFi Gagal!");
    lcd.setCursor(0, 1);
    lcd.print("Cek 2.4GHz Band");
#endif
}

// =====================================================================
//  KONTROL PERIFERAL
// =====================================================================
void setRelay(bool on) {
    relayState = on;
    digitalWrite(PIN_RELAY, on ? RELAY_ON : RELAY_OFF);
}

void setLedHijau(bool on) {
    led1State = on;
    digitalWrite(PIN_LED_HIJAU, on ? LED_ON : LED_OFF);
}

void setLedMerah(bool on) {
    led2State = on;
    digitalWrite(PIN_LED_MERAH, on ? LED_ON : LED_OFF);
}

// Bunyikan buzzer secara non-blocking via FreeRTOS Task
void bunyikanBuzzer(int kali) {
    xTaskCreate(
        [](void* param) {
            int n = (int)param;
            for (int i = 0; i < n; i++) {
                digitalWrite(PIN_BUZZER, BUZZER_ON);
                vTaskDelay(200 / portTICK_PERIOD_MS);
                digitalWrite(PIN_BUZZER, BUZZER_OFF);
                if (i < n - 1) vTaskDelay(120 / portTICK_PERIOD_MS);
            }
            vTaskDelete(NULL);
        },
        "buzz", 1536, (void*)kali, 1, NULL
    );
}

// =====================================================================
//  EVENT ABSENSI (Dipanggil dari endpoint /absen)
// =====================================================================
void onAbsenBerhasil(const char* nama) {
    setLedHijau(true);
    setLedMerah(false);
    bunyikanBuzzer(1);

    char baris2[17];
    snprintf(baris2, sizeof(baris2), "%-.16s", (nama && strlen(nama) > 0) ? nama : "Selamat Datang");
    lcdTampil("Absen Berhasil!", baris2);

    feedbackEndTime = millis() + 3500;
    feedbackActive = true;
}

void onAbsenGagal() {
    setLedHijau(false);
    setLedMerah(true);
    bunyikanBuzzer(3);

    lcdTampil("Akses Ditolak!", "Wajah Tdk Kenal");

    feedbackEndTime = millis() + 3500;
    feedbackActive = true;
}

// =====================================================================
//  SENSOR SUHU & KONTROL KIPAS OTOMATIS
// =====================================================================
float bacaSuhu() {
    // Sensor suhu digital (KY-028 / modul comparator): HIGH saat panas
    int val = digitalRead(PIN_SUHU);
    if (val == HIGH) {
        suhuSekarang = 34.0;  // Sensor mendeteksi panas
    } else {
        if (suhuSekarang > 30.0) suhuSekarang = 28.0;  // Kembali normal
    }
    return suhuSekarang;
}

void cekSuhuDanKipas() {
    if (millis() - lastSuhuCheck < 2500) return;
    lastSuhuCheck = millis();

    float temp = bacaSuhu();

    if (temp >= SUHU_PANAS && !relayState) {
        setRelay(true);
        if (!feedbackActive) lcdStandby();
    } else if (temp <= SUHU_NORMAL && relayState) {
        setRelay(false);
        if (!feedbackActive) lcdStandby();
    }
}

// =====================================================================
//  HTTP HANDLER: Halaman Utama (port 80 /)
// =====================================================================
static esp_err_t index_handler(httpd_req_t* req) {
    const char* html =
        "<!DOCTYPE html><html><head><meta name='viewport' content='width=device-width,initial-scale=1'>"
        "<title>BisaGym Kiosk</title>"
        "<style>body{text-align:center;font-family:sans-serif;background:#111;color:#eee;padding:10px}"
        "button{padding:8px 14px;margin:4px;border:none;border-radius:6px;cursor:pointer;font-weight:bold}"
        ".g{background:#10b981;color:#fff}.b{background:#3b82f6;color:#fff}"
        ".r{background:#ef4444;color:#fff}.d{background:#374151;color:#eee}</style></head>"
        "<body>"
        "<h2>BisaGym Kiosk</h2>"
        "<img id='cam' style='max-width:100%;border-radius:8px'>"
        "<p>Resolusi: "
        "<select onchange='setRes(this.value)'>"
        "<option value='5'>QVGA 320x240</option>"
        "<option value='8' selected>VGA 640x480</option>"
        "<option value='9'>SVGA 800x600</option>"
        "</select></p>"
        "<hr style='border:1px solid #333;margin:15px 0'>"
        "<h3>Simulasi Absensi</h3><p>"
        "<button class='g' onclick=\"fetch('/absen?status=berhasil&name=Demo')\">Absen OK (Beep 1x)</button>"
        "<button class='r' onclick=\"fetch('/absen?status=gagal')\">Absen Gagal (Beep 3x)</button></p>"
        "<h3>Kontrol Kipas</h3><p>"
        "<button class='b' onclick=\"fetch('/relay?state=1')\">Kipas ON</button>"
        "<button class='d' onclick=\"fetch('/relay?state=0')\">Kipas OFF</button></p>"
        "<p><a style='color:#6cf' href='/capture' target='_blank'>Foto</a> | "
        "<a style='color:#6cf' href='/status' target='_blank'>Status</a> | "
        "<a style='color:#a3e635' href='/suhu' target='_blank'>Suhu</a></p>"
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

// =====================================================================
//  HTTP HANDLER: Ganti Resolusi /size?v=N
// =====================================================================
static esp_err_t size_handler(httpd_req_t* req) {
    char query[32], val[8];
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK &&
        httpd_query_key_value(query, "v", val, sizeof(val)) == ESP_OK) {
        int v = atoi(val);
        if (v >= FRAMESIZE_QQVGA && v <= FRAMESIZE_UXGA) {
            sensor_t* s = esp_camera_sensor_get();
            if (s) s->set_framesize(s, (framesize_t)v);
        }
    }
    httpd_resp_set_type(req, "text/plain");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, "OK", HTTPD_RESP_USE_STRLEN);
}

// =====================================================================
//  HTTP HANDLER: Capture Foto /capture
// =====================================================================
static esp_err_t capture_handler(httpd_req_t* req) {
    camera_fb_t* fb = NULL;
    for (int i = 0; i < 5 && !fb; i++) {
        fb = esp_camera_fb_get();
        if (!fb) vTaskDelay(150 / portTICK_PERIOD_MS);
    }
    if (!fb) {
        httpd_resp_send_500(req);
        return ESP_FAIL;
    }
    httpd_resp_set_type(req, "image/jpeg");
    httpd_resp_set_hdr(req, "Content-Disposition", "inline; filename=capture.jpg");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    httpd_resp_set_hdr(req, "Cache-Control", "no-cache, no-store, must-revalidate");
    esp_err_t res = httpd_resp_send(req, (const char*)fb->buf, fb->len);
    esp_camera_fb_return(fb);
    return res;
}

// =====================================================================
//  HTTP HANDLER: Status JSON /status
// =====================================================================
static esp_err_t status_handler(httpd_req_t* req) {
    char json[384];
    snprintf(json, sizeof(json),
        "{\"status\":\"ok\",\"board\":\"BisaGym-Kiosk\","
        "\"ip\":\"%s\",\"ssid\":\"%s\","
        "\"suhu\":%.1f,\"kipas\":%s,"
        "\"led_hijau\":%s,\"led_merah\":%s,"
        "\"relay\":%s,\"heap\":%u,"
        "\"uptime\":%lu}",
        WiFi.localIP().toString().c_str(), wifiSSID.c_str(),
        suhuSekarang, relayState ? "true" : "false",
        led1State ? "true" : "false", led2State ? "true" : "false",
        relayState ? "true" : "false", ESP.getFreeHeap(),
        millis() / 1000);
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, json, HTTPD_RESP_USE_STRLEN);
}

// =====================================================================
//  HTTP HANDLER: Absensi Feedback /absen?status=berhasil|gagal&name=...
// =====================================================================
static esp_err_t absen_handler(httpd_req_t* req) {
    char query[128] = {0};
    char statusVal[16] = {0};
    char nameVal[32] = {0};

    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK) {
        httpd_query_key_value(query, "status", statusVal, sizeof(statusVal));
        httpd_query_key_value(query, "name", nameVal, sizeof(nameVal));
    }

    char json[128];
    if (strcmp(statusVal, "berhasil") == 0) {
        onAbsenBerhasil(nameVal);
        snprintf(json, sizeof(json), "{\"result\":\"ok\",\"action\":\"berhasil\",\"name\":\"%s\"}", nameVal);
    } else {
        onAbsenGagal();
        snprintf(json, sizeof(json), "{\"result\":\"ok\",\"action\":\"gagal\"}");
    }

    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, json, HTTPD_RESP_USE_STRLEN);
}

// =====================================================================
//  HTTP HANDLER: Relay Kipas /relay?state=0|1
// =====================================================================
static esp_err_t relay_handler(httpd_req_t* req) {
    char query[32], val[4];
    bool state = false;
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK &&
        httpd_query_key_value(query, "state", val, sizeof(val)) == ESP_OK) {
        state = (atoi(val) == 1);
    }
    setRelay(state);
    if (!feedbackActive) lcdStandby();

    char json[64];
    snprintf(json, sizeof(json), "{\"relay\":%s}", relayState ? "true" : "false");
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, json, HTTPD_RESP_USE_STRLEN);
}

// =====================================================================
//  HTTP HANDLER: Suhu & Kipas /suhu  atau /suhu?val=35 (simulasi)
// =====================================================================
static esp_err_t suhu_handler(httpd_req_t* req) {
    char query[32], val[8];
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK &&
        httpd_query_key_value(query, "val", val, sizeof(val)) == ESP_OK) {
        suhuSekarang = atof(val);  // Simulasi suhu manual
    }

    char json[128];
    snprintf(json, sizeof(json),
        "{\"suhu\":%.1f,\"kipas\":%s,\"threshold_panas\":%.1f,\"threshold_normal\":%.1f}",
        suhuSekarang, relayState ? "true" : "false", SUHU_PANAS, SUHU_NORMAL);
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, json, HTTPD_RESP_USE_STRLEN);
}

// =====================================================================
//  HTTP HANDLER: LED Manual /led?n=1&s=1  (n=nomor led, s=0|1)
// =====================================================================
static esp_err_t led_handler(httpd_req_t* req) {
    char query[32], nVal[4], sVal[4];
    if (httpd_req_get_url_query_str(req, query, sizeof(query)) == ESP_OK) {
        httpd_query_key_value(query, "n", nVal, sizeof(nVal));
        httpd_query_key_value(query, "s", sVal, sizeof(sVal));
        int n = atoi(nVal);
        bool s = (atoi(sVal) == 1);
        if (n == 1) setLedHijau(s);
        else if (n == 2) setLedMerah(s);
    }
    char json[64];
    snprintf(json, sizeof(json), "{\"led1\":%s,\"led2\":%s}",
             led1State ? "true" : "false", led2State ? "true" : "false");
    httpd_resp_set_type(req, "application/json");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    return httpd_resp_send(req, json, HTTPD_RESP_USE_STRLEN);
}

// =====================================================================
//  MJPEG STREAM /stream (port 80 & 81)
// =====================================================================
static esp_err_t stream_handler(httpd_req_t* req) {
    esp_err_t res = ESP_OK;
    char partBuf[64];

    httpd_resp_set_type(req, "multipart/x-mixed-replace; boundary=frame");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    httpd_resp_set_hdr(req, "Cache-Control", "no-cache, no-store");

    int gagal = 0;
    while (true) {
        camera_fb_t* fb = esp_camera_fb_get();
        if (!fb) {
            gagal++;
            if (gagal > 10) break;
            vTaskDelay(100 / portTICK_PERIOD_MS);
            continue;
        }
        gagal = 0;

        res = httpd_resp_send_chunk(req, "\r\n--frame\r\n", 11);
        if (res == ESP_OK) {
            size_t hlen = snprintf(partBuf, sizeof(partBuf),
                "Content-Type: image/jpeg\r\nContent-Length: %u\r\n\r\n",
                (unsigned)fb->len);
            res = httpd_resp_send_chunk(req, partBuf, hlen);
        }
        if (res == ESP_OK) {
            res = httpd_resp_send_chunk(req, (const char*)fb->buf, fb->len);
        }
        esp_camera_fb_return(fb);

        if (res != ESP_OK) break;
        vTaskDelay(30 / portTICK_PERIOD_MS);
    }
    return res;
}

// =====================================================================
//  START WEB SERVER (port 80 + port 81)
// =====================================================================
void startWebServer() {
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();
    config.max_uri_handlers = 16;
    config.stack_size = 8192;

    // Port 80: Semua endpoint
    config.server_port = 80;
    if (httpd_start(&httpServer, &config) == ESP_OK) {
        httpd_uri_t uris[] = {
            { "/",        HTTP_GET, index_handler,   NULL },
            { "/capture", HTTP_GET, capture_handler, NULL },
            { "/size",    HTTP_GET, size_handler,    NULL },
            { "/status",  HTTP_GET, status_handler,  NULL },
            { "/stream",  HTTP_GET, stream_handler,  NULL },
            { "/absen",   HTTP_GET, absen_handler,   NULL },
            { "/relay",   HTTP_GET, relay_handler,   NULL },
            { "/suhu",    HTTP_GET, suhu_handler,    NULL },
            { "/led",     HTTP_GET, led_handler,     NULL },
        };
        for (auto& uri : uris) httpd_register_uri_handler(httpServer, &uri);
    }

    // Port 81: Khusus MJPEG stream
    config.server_port = 81;
    config.ctrl_port += 1;
    if (httpd_start(&streamServer, &config) == ESP_OK) {
        httpd_uri_t streamUri = { "/stream", HTTP_GET, stream_handler, NULL };
        httpd_register_uri_handler(streamServer, &streamUri);
    }
}

// =====================================================================
//  INISIALISASI KAMERA
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
    config.xclk_freq_hz = 20000000;          // 20 MHz standar official CameraWebServer
    config.frame_size   = FRAMESIZE_UXGA;    // Init besar dulu, lalu diturunkan ke VGA
    config.pixel_format = PIXFORMAT_JPEG;
    config.grab_mode    = CAMERA_GRAB_WHEN_EMPTY;
    config.fb_location  = CAMERA_FB_IN_PSRAM;
    config.jpeg_quality = 12;
    config.fb_count     = 1;

    if (psramFound()) {
        config.jpeg_quality = 10;
        config.fb_count     = 2;
        config.grab_mode    = CAMERA_GRAB_LATEST;
    } else {
        config.frame_size   = FRAMESIZE_SVGA;
        config.fb_location  = CAMERA_FB_IN_DRAM;
    }

    esp_err_t err = esp_camera_init(&config);
    if (err != ESP_OK) return false;

    sensor_t* s = esp_camera_sensor_get();
    if (s) {
        if (s->id.PID == OV3660_PID) {
            s->set_vflip(s, 1);
            s->set_brightness(s, 1);
            s->set_saturation(s, -2);
        }
        s->set_framesize(s, FRAMESIZE_VGA);
    }
    return true;
}

// =====================================================================
//  KONEKSI WI-FI (Multi-SSID — Otomatis Coba Semua)
// =====================================================================
bool connectWiFi() {
    WiFi.persistent(false);
    WiFi.mode(WIFI_STA);
    WiFi.setAutoReconnect(true);

    for (int w = 0; w < wifiCount; w++) {
        lcdTampil("Cari WiFi...", wifiList[w].ssid);

        // LED Merah berkedip pelan saat mencari WiFi
        setLedMerah(true);

        WiFi.begin(wifiList[w].ssid, wifiList[w].password);
        WiFi.setSleep(false);  // Matikan sleep agar stream stabil

        int tunggu = 0;
        while (WiFi.status() != WL_CONNECTED && tunggu < 30) {
            delay(500);
            tunggu++;
            // Kedipkan LED Merah saat proses koneksi
            setLedMerah(tunggu % 2 == 0);
        }

        if (WiFi.status() == WL_CONNECTED) {
            wifiSSID = wifiList[w].ssid;
            setLedMerah(false);
            // Kedipkan LED Hijau 3x sebagai tanda berhasil
            for (int i = 0; i < 3; i++) {
                setLedHijau(true);  delay(150);
                setLedHijau(false); delay(150);
            }
            return true;
        }
        WiFi.disconnect();
        delay(500);
    }

    // Semua WiFi gagal
    setLedMerah(true);
    lcdWifiGagal();
    return false;
}

// =====================================================================
//  HELPER: Ambil nilai string dari JSON sederhana
// =====================================================================
String extractJsonString(const String& json, const char* key) {
    String pattern = String("\"") + key + "\":\"";
    int idx = json.indexOf(pattern);
    if (idx < 0) return "";
    int start = idx + pattern.length();
    int end = json.indexOf("\"", start);
    if (end < 0) return "";
    return json.substring(start, end);
}

// =====================================================================
//  CLOUD SYNC TASK (Upload Railway + Poll Feedback Buzzer/LED)
// =====================================================================
void cloudSyncLoop(void* param) {
    WiFiClientSecure secureClient;
    secureClient.setInsecure();

    HTTPClient https;
    unsigned long lastFeedbackPoll = 0;
    unsigned long lastLog = 0;
    int okCount = 0;
    int failCount = 0;

    while (true) {
        if (WiFi.status() == WL_CONNECTED) {
            // 1. Upload frame kamera ke Railway
            camera_fb_t* fb = esp_camera_fb_get();
            if (fb) {
                if (https.begin(secureClient, railwayUploadUrl)) {
                    https.addHeader("Content-Type", "image/jpeg");
                    https.setTimeout(3500);
                    int code = https.POST(fb->buf, fb->len);
                    if (code == 200) okCount++;
                    else failCount++;
                    https.end();
                } else {
                    failCount++;
                }
                esp_camera_fb_return(fb);
            }

            // 2. Cek perintah Buzzer/LED/LCD dari website (fitfacely.com)
            if (millis() - lastFeedbackPoll >= feedbackPollMs) {
                lastFeedbackPoll = millis();
                if (https.begin(secureClient, feedbackUrl)) {
                    https.setTimeout(3000);
                    int code = https.GET();
                    if (code == 200) {
                        String body = https.getString();
                        String id     = extractJsonString(body, "id");
                        String status = extractJsonString(body, "status");
                        String name   = extractJsonString(body, "name");

                        if (id.length() > 0 && id != lastFeedbackId) {
                            lastFeedbackId = id;
                            if (status == "berhasil") {
                                onAbsenBerhasil(name.c_str());
                            } else if (status == "gagal") {
                                onAbsenGagal();
                            }
                        }
                    }
                    https.end();
                }
            }

            if (millis() - lastLog >= 10000) {
                lastLog = millis();
                Serial.printf("[Cloud] 10s: %d OK, %d Gagal | Heap: %u\n",
                              okCount, failCount, ESP.getFreeHeap());
                okCount = 0;
                failCount = 0;
            }
        }
        vTaskDelay(uploadIntervalMs / portTICK_PERIOD_MS);
    }
}

// =====================================================================
//  SETUP
// =====================================================================
void setup() {
    Serial.begin(115200);
    Serial.setDebugOutput(false);  // Matikan spam HAL
    delay(500);
    Serial.println("\n[BisaGym] Smart Kiosk — Mode Wi-Fi Lokal");

    // ── LANGKAH 1: Kamera PERTAMA ────────────────────────────────
    bool camOk = initCamera();
    Serial.printf("[CAM] %s\n", camOk ? "OK (VGA 640x480)" : "GAGAL — cek kabel pita kamera!");

    // ── LANGKAH 2: Inisialisasi GPIO Periferal ───────────────────
    // PENTING: Ini SETELAH kamera agar tidak konflik I2C/pin
    pinMode(PIN_RELAY, OUTPUT);
    digitalWrite(PIN_RELAY, RELAY_OFF);

    pinMode(PIN_LED_HIJAU, OUTPUT);
    digitalWrite(PIN_LED_HIJAU, LED_OFF);

    pinMode(PIN_LED_MERAH, OUTPUT);
    digitalWrite(PIN_LED_MERAH, LED_OFF);

    pinMode(PIN_BUZZER, OUTPUT);
    digitalWrite(PIN_BUZZER, BUZZER_OFF);

    pinMode(PIN_SUHU, INPUT);

    // ── LANGKAH 3: Inisialisasi LCD ──────────────────────────────
    // HANYA jika library LiquidCrystal_I2C terpasang di Arduino IDE
#if HAS_LCD
    Serial.println("[LCD] Library ditemukan — LCD aktif");
#else
    Serial.println("[LCD] Library belum terpasang — mode tanpa LCD");
    Serial.println("[LCD] Tips: Pasang 'LiquidCrystal I2C' di Arduino Library Manager");
#endif
    lcdInit();

    // ── LANGKAH 4: Hubungkan Wi-Fi ──────────────────────────────
    bool wifiOk = connectWiFi();

    if (wifiOk && camOk) {
        MDNS.begin("bisagym-kiosk");
        startWebServer();

        // Jalankan task upload Railway + poll feedback di Core 1
        xTaskCreatePinnedToCore(
            cloudSyncLoop,
            "cloudSync",
            8192,
            NULL,
            1,
            &cloudTaskHandle,
            1
        );

        String ip = WiFi.localIP().toString();
        lcdTampilIP("Railway Aktif!");

        // Beep 1x pendek tanda kiosk siap
        bunyikanBuzzer(1);

        Serial.println("\n========================================================");
        Serial.println("     BisaGym Smart Kiosk ONLINE! (Mode Railway Cloud)   ");
        Serial.println("========================================================");
        Serial.printf("  Wi-Fi     : %s\n", wifiSSID.c_str());
        Serial.printf("  IP Lokal  : %s\n", ip.c_str());
        Serial.printf("  Railway   : https://esp32cam-production-704ea82e.up.railway.app\n");
        Serial.printf("  Feedback  : %s\n", feedbackUrl);
        Serial.println("========================================================");
        Serial.println("Masukkan URL Railway di atas ke halaman Absensi fitfacely.com.");
        Serial.println("========================================================\n");
    } else {
        Serial.printf("[ERROR] WiFi: %s | Kamera: %s\n",
                      wifiOk ? "OK" : "GAGAL", camOk ? "OK" : "GAGAL");
        // LED Merah menyala terus jika gagal
        setLedMerah(true);
        // Buzzer 5x cepat sebagai alarm error
        bunyikanBuzzer(5);
    }
}

// =====================================================================
//  LOOP UTAMA
// =====================================================================
void loop() {
    // 1. Cek timer feedback LED (reset ke standby setelah 3.5 detik)
    if (feedbackActive && millis() >= feedbackEndTime) {
        setLedHijau(false);
        setLedMerah(false);
        feedbackActive = false;
        lcdStandby();
    }

    // 2. Cek sensor suhu & kontrol kipas otomatis
    cekSuhuDanKipas();

    // 3. Update LCD standby berkala (setiap 4 detik)
    if (!feedbackActive && millis() - lastLcdRefresh >= 4000) {
        lastLcdRefresh = millis();
        lcdStandby();
    }

    // 4. Cek koneksi WiFi setiap 15 detik (auto-reconnect)
    if (millis() - lastWifiCheck >= 15000) {
        lastWifiCheck = millis();
        if (WiFi.status() != WL_CONNECTED) {
            WiFi.disconnect();
            // Coba reconnect ke WiFi terakhir yang berhasil
            WiFi.begin();
        }
    }

    delay(20);
}
