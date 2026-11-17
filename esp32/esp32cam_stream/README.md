# ESP32-CAM Stream Server untuk BisaGym

Sketch ini menjalankan web server di ESP32-CAM yang menyediakan stream kamera secara live. Digunakan oleh halaman **Scan Absensi Member** BisaGym sebagai sumber kamera alternatif selain Webcam.

---

## Endpoint yang Tersedia

| Endpoint | Port | Fungsi |
|---|---|---|
| `http://<ip>:81/stream` | 81 | MJPEG live stream — ditampilkan di halaman sebagai preview |
| `http://<ip>/capture` | 80 | Ambil satu frame JPEG — dikirim ke API biometrik untuk verifikasi wajah |
| `http://<ip>/status` | 80 | Cek status perangkat (JSON) |

---

## Komponen

| Komponen | Keterangan |
|---|---|
| ESP32-CAM (AI-Thinker) | Modul kamera utama |
| Kabel USB-TTL (atau programmer ESP32-CAM) | Untuk upload sketch |
| Catu daya 5 V / min 500 mA | ESP32-CAM butuh arus cukup |

> **Catatan:** Jangan gunakan 3.3 V untuk catu daya utama ESP32-CAM — sering menyebabkan kamera gagal init atau koneksi Wi-Fi tidak stabil.

---

## Langkah Pemasangan

### 1. Konfigurasi Wi-Fi
Buka file `esp32cam_stream.ino` dan ganti dua baris ini:

```cpp
const char* WIFI_SSID     = "NAMA_WIFI_ANDA";      // <-- ganti ini
const char* WIFI_PASSWORD = "PASSWORD_WIFI_ANDA";  // <-- ganti ini
```

### 2. Install Board ESP32 di Arduino IDE
1. Buka Arduino IDE → **File** → **Preferences**.
2. Tambahkan URL ini ke *Additional boards manager URLs*:
   ```
   https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   ```
3. Buka **Tools** → **Board** → **Boards Manager** → cari `esp32` → Install **esp32 by Espressif Systems**.

### 3. Upload Sketch
1. Pilih board: **Tools → Board → ESP32 Arduino → AI Thinker ESP32-CAM**
2. Pastikan pin `IO0` di-*ground* saat upload (mode flash), atau gunakan FTDI programmer.
3. Klik **Upload**.
4. Setelah selesai, cabut jumper `IO0–GND`, tekan tombol Reset pada ESP32-CAM.
5. Buka **Serial Monitor** (115200 baud) → catat **alamat IP** yang muncul, contoh:
   ```
   [WiFi] Terhubung! Alamat IP: 192.168.1.50
   ```

### 4. Pakai di Halaman Absensi BisaGym
1. Buka halaman **Scan Absensi Member**: [http://127.0.0.1:8000/attendance](http://127.0.0.1:8000/attendance)
2. Pilih tab **Kiosk Wajah**.
3. Klik tombol **ESP32-CAM** di pemilih Sumber Kamera.
4. Ketik IP ESP32-CAM (misal `192.168.1.50`) di kolom yang muncul.
5. Klik **Uji** — jika berhasil, preview stream langsung tampil.
6. Tekan **Mulai Check-in Wajah** untuk verifikasi.

---

## Troubleshooting

| Masalah | Solusi |
|---|---|
| Kamera gagal init (`0x105`) | Pastikan catu daya ≥ 5 V / 500 mA. Coba ganti kabel USB. |
| Wi-Fi tidak terhubung | Periksa SSID & password. ESP32-CAM hanya mendukung jaringan 2.4 GHz. |
| Stream lambat / putus-putus | Dekatkan ke router. Kurangi `FRAME_SIZE` ke `FRAMESIZE_QVGA` (320×240). |
| IP berubah setiap reboot | Atur IP statis di router (DHCP reservation berdasarkan MAC address). |
| Halaman tidak bisa akses stream | Pastikan browser dan ESP32-CAM satu jaringan Wi-Fi. Stream tidak bisa diakses lintas jaringan langsung dari browser (server Laravel bertindak sebagai proxy). |

---

## Hubungan dengan Komponen BisaGym Lainnya

```
Browser (halaman Absensi)
     │
     │  Pilih "ESP32-CAM" → isi IP
     │
     ▼
http://<ip>:81/stream   ──────────────── ESP32-CAM (preview live di halaman)
     │
     │  Tekan "Mulai Check-in"
     ▼
POST /attendance/face-checkin  ──────── Laravel (AttendanceController)
     │                                       │
     │  parameter: esp32_url                 │  fetchEsp32Frame()
     │                                       ▼
     │                              http://<ip>/capture  ── ESP32-CAM (ambil 1 frame)
     │                                       │
     │                                       ▼
     │                              bisagym-api:8001/checkin (YuNet + SFace AI)
     │                                       │
     └───────────── Hasil check-in ──────────┘
                    (ALLOW / DENY)
```

