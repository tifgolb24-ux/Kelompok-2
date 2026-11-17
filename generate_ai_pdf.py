# -*- coding: utf-8 -*-
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    HRFlowable, PageBreak, KeepTogether
)
from reportlab.lib.enums import TA_JUSTIFY, TA_CENTER, TA_LEFT

OUTPUT_PROJECT = r"D:\Projek_Web\laragon\www\PBL\Website-BisaGym\Metode_AI_dan_Pengolahan_Citra_BisaGym.pdf"
OUTPUT_DESKTOP = r"C:\Users\Asus\Desktop\Metode_AI_dan_Pengolahan_Citra_BisaGym.pdf"

styles = getSampleStyleSheet()

DARK_BLUE  = colors.HexColor("#1e3a5f")
MID_BLUE   = colors.HexColor("#2563eb")
LIGHT_BLUE = colors.HexColor("#dbeafe")
GRAY_BG    = colors.HexColor("#f8fafc")
BORDER_CLR = colors.HexColor("#cbd5e1")
WHITE      = colors.white
BLACK      = colors.HexColor("#0f172a")

def make_style(name, **kw):
    return ParagraphStyle(name, **kw)

title_style = make_style("DocTitle",
    fontSize=18, leading=24, textColor=WHITE,
    alignment=TA_CENTER, fontName="Helvetica-Bold", spaceAfter=5)

sub_style = make_style("DocSub",
    fontSize=10.5, leading=15, textColor=colors.HexColor("#bfdbfe"),
    alignment=TA_CENTER, fontName="Helvetica", spaceAfter=3)

meta_style = make_style("DocMeta",
    fontSize=8, leading=11, textColor=colors.HexColor("#93c5fd"),
    alignment=TA_CENTER, fontName="Helvetica")

h1_style = make_style("H1",
    fontSize=12, leading=17, textColor=DARK_BLUE,
    fontName="Helvetica-Bold", spaceBefore=12, spaceAfter=5)

h2_style = make_style("H2",
    fontSize=10, leading=14, textColor=DARK_BLUE,
    fontName="Helvetica-Bold", spaceBefore=8, spaceAfter=3)

body_style = make_style("BodyP",
    fontSize=9, leading=14.5, textColor=BLACK,
    alignment=TA_JUSTIFY, spaceAfter=5, fontName="Helvetica")

bullet_style = make_style("BulletP",
    fontSize=9, leading=13.5, textColor=BLACK,
    leftIndent=14, spaceAfter=3, fontName="Helvetica")

formula_box_style = make_style("FormulaBox",
    fontSize=9, leading=13, textColor=DARK_BLUE,
    fontName="Courier-Bold", alignment=TA_CENTER)

formula_desc_style = make_style("FormulaDesc",
    fontSize=8, leading=11, textColor=colors.HexColor("#334155"),
    alignment=TA_LEFT, fontName="Helvetica")

def p(text, st=body_style):
    return Paragraph(text, st)

def bullet(text):
    return Paragraph(f"• {text}", bullet_style)

def hr():
    return HRFlowable(width="100%", thickness=1.2, color=MID_BLUE, spaceAfter=5, spaceBefore=2)

def formula_block(formula_text, description_text=""):
    data = [
        [Paragraph(formula_text, formula_box_style)],
    ]
    if description_text:
        data.append([Paragraph(description_text, formula_desc_style)])
    
    t = Table(data, colWidths=[16.5*cm])
    t.setStyle(TableStyle([
        ("BACKGROUND", (0,0), (-1,-1), colors.HexColor("#f1f5f9")),
        ("BOX", (0,0), (-1,-1), 1, colors.HexColor("#94a3b8")),
        ("TOPPADDING", (0,0), (-1,-1), 5),
        ("BOTTOMPADDING", (0,0), (-1,-1), 5),
        ("LEFTPADDING", (0,0), (-1,-1), 8),
        ("RIGHTPADDING", (0,0), (-1,-1), 8),
    ]))
    return t

doc = SimpleDocTemplate(
    OUTPUT_PROJECT,
    pagesize=A4,
    leftMargin=2*cm, rightMargin=2*cm,
    topMargin=1.8*cm, bottomMargin=1.8*cm,
    title="Dokumentasi Metode AI, Citra, dan Struktur File bisagym-api",
    author="Website BisaGym Team",
    subject="Kecerdasan Buatan, Pengolahan Citra Digital, dan Arsitektur Kode",
)

story = []

# COVER HEADER
cover_data = [
    [Paragraph("DOKUMENTASI METODE AI, PENGOLAHAN CITRA & STRUKTUR FILE", title_style)],
    [Paragraph("Sistem Presensi Biometrik & Kiosk Website BisaGym", sub_style)],
    [Paragraph("Arsitektur Pipeline, Model Deep Learning, Landasan Matematika, dan Penjelasan File bisagym-api", sub_style)],
    [Spacer(1, 4)],
    [Paragraph("OpenCV 4.13 · YuNet (CNN Detection) · SFace (SphereFace 2 Embedding) · FastAPI · SQLite", meta_style)],
    [Paragraph("Repository: github.com/anugrah-1-dev/CitradanAI · November 2026", meta_style)],
]
cover_table = Table(cover_data, colWidths=[16.5*cm])
cover_table.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,-1), DARK_BLUE),
    ("TOPPADDING", (0,0), (-1,-1), 10),
    ("BOTTOMPADDING", (0,0), (-1,-1), 10),
    ("LEFTPADDING", (0,0), (-1,-1), 14),
    ("RIGHTPADDING", (0,0), (-1,-1), 14),
    ("ROUNDEDCORNERS", [6,6,6,6]),
]))
story.append(cover_table)
story.append(Spacer(1, 8))

# BAB 1
story.append(Paragraph("1. Ikhtisar Pipeline Kecerdasan Buatan & Citra", h1_style))
story.append(hr())
story.append(p("Sistem presensi biometrik pada Website BisaGym menggabungkan teknik <b>Pengolahan Citra Digital (PCD)</b> untuk pra-pemrosesan dan validasi kualitas visual, serta model <b>Deep Learning</b> (Convolutional Neural Network) untuk deteksi serta pengenalan pola wajah. Seluruh proses dieksekusi secara berurutan dalam empat tahapan pipeline:"))
story.append(bullet("<b>Tahap 1 (Quality Assessment):</b> Memfilter frame kamera dari keburaman, pencahayaan buruk, dan ukuran wajah yang terlalu kecil."))
story.append(bullet("<b>Tahap 2 (Face Detection & Alignment):</b> Menemukan posisi wajah dan menyelaraskan orientasi berdasarkan 5 titik landmark kanonik."))
story.append(bullet("<b>Tahap 3 (Feature Extraction / Embedding):</b> Memetakan visual wajah menjadi vektor representasi 128-dimensi ternormalisasi L2."))
story.append(bullet("<b>Tahap 4 (Face Matching & Decision Rules):</b> Menghitung derajat kemiripan antar vektor menggunakan Cosine Similarity dan aturan ambiguitas."))

story.append(Spacer(1, 4))

# BAB 2
story.append(Paragraph("2. Pra-Pemrosesan & Validasi Kualitas Citra (Quality Assessment)", h1_style))
story.append(hr())
story.append(p("Sebelum citra diproses oleh jaringan syaraf tiruan, citra wajah dipotong (crop) dan dianalisis mutunya pada fungsi <i>_quality()</i> di modul <i>biometrics.py</i> guna mencegah kegagalan identifikasi (False Reject / False Accept):"))

story.append(Paragraph("2.1 Deteksi Keburaman (Blur Detection) — Operator Laplacian", h2_style))
story.append(p("Ketajaman citra diukur menggunakan turunan parsial kedua pada ruang spasial citra keabuan (grayscale). Operator diferensial Laplacian didefinisikan sebagai:"))
story.append(formula_block(
    "&nabla;&sup2; f(x, y) = &part;&sup2;f / &part;x&sup2; + &part;&sup2;f / &part;y&sup2;",
    "Dihitung melalui konvolusi citra dengan kernel 3x3: [ [0, 1, 0], [1, -4, 1], [0, 1, 0] ]"
))
story.append(Spacer(1, 3))
story.append(p("Skor ketajaman ditentukan oleh <b>Variansi Laplacian</b> (Variance of Laplacian):"))
story.append(formula_block(
    "Var(L) = (1 / N) * &sum; [ L(x, y) - &mu;_L ]&sup2;",
    "Di mana L(x, y) adalah hasil konvolusi Laplacian dan &mu;_L adalah rata-ratanya.<br/>"
    "<b>Aturan Keputusan:</b> Jika Var(L) &lt; 80.0, citra dianggap buram &rarr; Ditolak (IMAGE_TOO_BLURRY)."
))

story.append(Spacer(1, 3))
story.append(Paragraph("2.2 Evaluasi Pencahayaan (Exposure) & Pixel Clipping", h2_style))
story.append(p("Tingkat eksposur dinilai dari nilai intensitas rata-rata (&mu;) piksel citra keabuan serta proporsi piksel saturasi:"))
story.append(formula_block(
    "&mu; = (1 / N) * &sum; I(x, y)<br/>"
    "Fraction_clipped = Count( I(x,y) &le; 5  atau  I(x,y) &ge; 250 ) / N",
    "<b>Aturan Keputusan:</b><br/>"
    "• Rentang aman: 45.0 &le; &mu; &le; 210.0 (skala 0 - 255)<br/>"
    "• Fraksi saturasi: Fraction_clipped &le; 0.30 (maksimal 30% piksel mentok hitam/putih)<br/>"
    "Jika melanggar &rarr; Ditolak (BAD_EXPOSURE)."
))

story.append(Spacer(1, 3))
story.append(Paragraph("2.3 Rasio Ukuran Wajah (Face Size Ratio)", h2_style))
story.append(p("Untuk memastikan fitur wajah memiliki resolusi yang cukup untuk diekstraksi:"))
story.append(formula_block(
    "min(W_box, H_box) &ge; 80 piksel<br/>"
    "Size_Ratio = min(W_box, H_box) / min(W_img, H_img) &ge; 0.10",
    "Wajah minimal berukuran 80x80 piksel dan menempati sekurang-kurangnya 10% dari dimensi terkecil frame.<br/>"
    "Jika lebih kecil &rarr; Ditolak (FACE_TOO_SMALL)."
))

story.append(PageBreak())

# BAB 3
story.append(Paragraph("3. Deteksi Wajah & Penyelarasan (YuNet + Affine Transform)", h1_style))
story.append(hr())
story.append(p("Model <b>YuNet</b> (<i>face_detection_yunet_2023mar.onnx</i>) adalah arsitektur CNN ringan berbasis <i>anchor-free single-stage object detector</i> yang dioptimalkan untuk inferensi waktu-nyata di perangkat edge/CPU."))
story.append(bullet("<b>Output Deteksi:</b> Menghasilkan koordinat Bounding Box <i>(x, y, w, h)</i>, Confidence Score, serta 5 titik koordinat Facial Landmark (mata kanan, mata kiri, ujung hidung, sudut mulut kanan, sudut mulut kiri)."))
story.append(bullet("<b>Threshold Deteksi:</b> Skor keyakinan deteksi minimal &ge; 0.90 dan Non-Maximum Suppression (NMS) IoU threshold &le; 0.30."))
story.append(bullet("<b>Penyelarasan Wajah (Affine Transformation / alignCrop):</b> Wajah yang terdeteksi ditransformasikan secara geometris (rotasi dan penskalaan) sehingga posisi kedua mata sejajar secara horizontal terhadap pusat koordinat kanonik standar sebelum diumpankan ke model pengenal."))

story.append(Spacer(1, 5))

# BAB 4
story.append(Paragraph("4. Ekstraksi Fitur / Deep Learning Embedding (SFace)", h1_style))
story.append(hr())
story.append(p("Model <b>SFace</b> (<i>face_recognition_sface_2021dec.onnx</i>) menggunakan jaringan konvolusi dalam berbasis arsitektur <b>SphereFace 2</b> yang dilatih dengan fungsi objektif <i>Cosine Margin Loss</i>."))
story.append(p("Output model menghasilkan vektor ciri wajah (embedding) 128-dimensi: <b>F = [f_1, f_2, ..., f_128]</b>."))

story.append(Paragraph("4.1 Normalisasi L2 (Unit Vector Normalization)", h2_style))
story.append(p("Agar perbandingan jarak antar wajah tidak dipengaruhi oleh variasi magnitudo/kontras, vektor dinormalisasi menjadi vektor satuan (unit norm):"))
story.append(formula_block(
    "||F||_2 = &radic;( &sum;_{i=1}^{128} f_i&sup2; )<br/>"
    "V_hat = F / ||F||_2   &rArr;   ||V_hat||_2 = 1.0",
    "Setiap vektor yang disimpan dan dibandingkan selalu memiliki panjang Euclidean tepat sama dengan 1."
))

story.append(Spacer(1, 3))
story.append(Paragraph("4.2 Pembentukan Profil Member (Normalized Average dari 3 Sampel)", h2_style))
story.append(p("Saat pendaftaran (enrollment), member mengambil 3 pose (depan, sedikit kiri, sedikit kanan) menghasilkan vektor <b>V_1, V_2, V_3</b>. Sistem melakukan dua tahap:"))
story.append(bullet("<b>Uji Konsistensi:</b> CosineSimilarity(V_i, V_j) &ge; 0.45 untuk setiap pasangan sampel. Ini menjamin ketiga foto benar-benar berasal dari orang yang sama."))
story.append(bullet("<b>Rata-Rata Ternormalisasi (Normalized Average):</b>"))
story.append(formula_block(
    "V_avg = (1 / K) * &sum;_{k=1}^K V_k<br/>"
    "V_profile = V_avg / ||V_avg||_2",
    "Vektor gabungan V_profile inilah yang disimpan ke database SQLite (gym.db) sebagai cetak biru biometrik member."
))

story.append(Spacer(1, 5))

# BAB 5
story.append(Paragraph("5. Metode Pencocokan Wajah & Algoritma Keputusan", h1_style))
story.append(hr())
story.append(p("Saat presensi di kiosk atau kamera live, vektor wajah uji (A) dibandingkan dengan vektor profil terdaftar (B) menggunakan <b>Cosine Similarity</b>."))

story.append(Paragraph("5.1 Rumus Cosine Similarity", h2_style))
story.append(p("Kecocokan dihitung berdasarkan kosinus sudut antara kedua vektor pada ruang hiper-dimensi R^128:"))
story.append(formula_block(
    "CosineSimilarity(A, B) = (A &middot; B) / ( ||A||_2 * ||B||_2 ) = &sum;_{i=1}^{128} (A_i * B_i) / [ &radic;(&sum; A_i&sup2;) * &radic;(&sum; B_i&sup2;) ]",
    "Karena kedua vektor telah dinormalisasi L2 (||A||_2 = 1 dan ||B||_2 = 1), formulanya disederhanakan menjadi operasi <b>Dot Product</b>:<br/>"
    "<b>CosineSimilarity(A, B) = &sum;_{i=1}^{128} ( A_i * B_i )</b>"
))
story.append(p("Rentang nilai kemiripan bernilai antara <b>-1.0</b> (sangat berbeda) hingga <b>+1.0</b> (identik sempurna)."))

story.append(Spacer(1, 3))
story.append(Paragraph("5.2 Aturan Pengambilan Keputusan (Decision Rules)", h2_style))
story.append(p("Untuk mencegah kesalahan presensi (False Acceptance Rate / FAR = 0):"))
story.append(bullet("<b>Ambang Batas Kecocokan (Match Threshold):</b> Skor terbaik (Score_1) harus memenuhi <b>Score_1 &ge; 0.50</b>. Jika di bawah itu, sistem menolak dengan status <i>IDENTITY_NOT_FOUND</i>."))
story.append(bullet("<b>Margin Ambiguitas (Ambiguity Margin):</b> Jika terdapat kandidat mirip peringkat kedua (Score_2), selisih keduanya harus: <b>Score_1 - Score_2 &ge; 0.05</b>. Jika selisihnya kurang dari 0.05, sistem menolak dengan status <i>AMBIGUOUS_FACE_MATCH</i> untuk mencegah tertukar dengan anggota lain yang mirip/kembar."))
story.append(bullet("<b>Anti-Duplicate Cooldown:</b> Member yang telah presensi diberi jeda 60 detik agar tidak terabsen berulang kali saat masih berada di depan kamera (<i>DUPLICATE_CHECKIN</i>)."))

story.append(PageBreak())

# BAB 6
story.append(Paragraph("6. Tabel Konfigurasi Parameter & Threshold Teknis", h1_style))
story.append(hr())
story.append(p("Berikut daftar parameter numerik yang terkonfigurasi pada file <i>config.py</i> dan digunakan dalam perhitungan algoritma:"))

param_data = [
    ["Parameter Sistem", "Nilai Default", "Fungsi dan Makna Matematis"],
    ["face_engine", "opencv_sface", "Engine AI utama (OpenCV 4.13 + ONNX Runtime)"],
    ["face_detection_model", "YuNet (2023mar)", "Model CNN pendeteksi wajah dan 5 landmark"],
    ["face_recognition_model", "SFace (2021dec)", "Model CNN ekstraktor fitur wajah 128 dimensi"],
    ["embedding_dimension", "128", "Jumlah variabel float32 pembentuk vektor ciri"],
    ["face_blur_threshold", "80.0", "Batas minimal Variansi Laplacian (pencegah foto buram)"],
    ["face_min_exposure", "45.0", "Batas bawah rata-rata intensitas keabuan (pencegah foto gelap)"],
    ["face_max_exposure", "210.0", "Batas atas rata-rata intensitas keabuan (pencegah silau)"],
    ["face_max_clipped_fraction", "0.30 (30%)", "Maksimal proporsi piksel mentok 0-5 atau 250-255"],
    ["face_min_size_pixels", "80 piksel", "Dimensi sisi terpendek minimal bounding box wajah"],
    ["face_min_size_ratio", "0.10 (10%)", "Rasio minimal ukuran wajah terhadap frame video"],
    ["yunet_score_threshold", "0.90", "Confidence score minimal untuk meloloskan deteksi wajah"],
    ["yunet_nms_threshold", "0.30", "Batas IoU Non-Maximum Suppression antar kotak deteksi"],
    ["enrollment_consistency", "0.45", "Cosine similarity minimal antar 3 sampel pose pendaftaran"],
    ["face_match_threshold", "0.50", "Cosine similarity minimal untuk pengenalan identitas member"],
    ["ambiguity_margin", "0.05", "Selisih minimal antara skor peringkat ke-1 dan ke-2"],
    ["checkin_cooldown_seconds", "60 detik", "Jeda waktu wajib sebelum member dapat presensi kembali"],
]

param_table = Table(param_data, colWidths=[4.8*cm, 3.2*cm, 8.5*cm])
param_table.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), DARK_BLUE),
    ("TEXTCOLOR", (0,0), (-1,0), WHITE),
    ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"),
    ("FONTSIZE", (0,0), (-1,-1), 8),
    ("ROWBACKGROUNDS", (0,1), (-1,-1), [WHITE, GRAY_BG]),
    ("GRID", (0,0), (-1,-1), 0.5, BORDER_CLR),
    ("TOPPADDING", (0,0), (-1,-1), 3.5),
    ("BOTTOMPADDING", (0,0), (-1,-1), 3.5),
    ("LEFTPADDING", (0,0), (-1,-1), 6),
    ("FONTNAME", (0,1), (0,-1), "Courier"),
]))
story.append(param_table)

story.append(PageBreak())

# BAB 7: STRUKTUR FILE BISAGYM-API
story.append(Paragraph("7. Struktur & Deskripsi File Folder bisagym-api", h1_style))
story.append(hr())
story.append(p("Folder <b>bisagym-api/</b> adalah modul backend berbasis <b>FastAPI (Python 3.13)</b> yang bertindak sebagai mesin AI biometrik terpisah dari portal Laravel. Berikut rincian tugas dan fungsi dari setiap file di dalamnya:"))

story.append(Paragraph("7.1 File Model AI (runtime-models/)", h2_style))
model_files = [
    ["Nama File", "Ukuran", "Fungsi & Peranan dalam Sistem"],
    ["face_detection_yunet_2023mar.onnx", "232 KB", "Model CNN YuNet: Mendeteksi wajah, koordinat Bounding Box, dan 5 landmark."],
    ["face_recognition_sface_2021dec.onnx", "38.7 MB", "Model Deep Learning SFace: Ekstraksi fitur visual menjadi vektor embedding 128 float."],
]
t_models = Table(model_files, colWidths=[6.8*cm, 2.2*cm, 7.5*cm])
t_models.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), colors.HexColor("#166534")),
    ("TEXTCOLOR", (0,0), (-1,0), WHITE),
    ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"),
    ("FONTSIZE", (0,0), (-1,-1), 8),
    ("ROWBACKGROUNDS", (0,1), (-1,-1), [WHITE, colors.HexColor("#f0fdf4")]),
    ("GRID", (0,0), (-1,-1), 0.5, BORDER_CLR),
    ("TOPPADDING", (0,0), (-1,-1), 3.5),
    ("BOTTOMPADDING", (0,0), (-1,-1), 3.5),
    ("LEFTPADDING", (0,0), (-1,-1), 5),
    ("FONTNAME", (0,1), (0,-1), "Courier"),
]))
story.append(t_models)

story.append(Spacer(1, 4))
story.append(Paragraph("7.2 File Logika Pemrosesan & API (app/)", h2_style))
app_files = [
    ["File Script", "Kategori", "Deskripsi & Tugas Utama"],
    ["biometrics.py", "Engine Inti", "Eksekusi OpenCV YuNet & SFace, fungsi _quality() (Laplacian blur, exposure, crop), normalisasi L2, Cosine Similarity, dan kalkulasi embedding profil."],
    ["checkin.py", "State Machine", "Alur presensi kiosk: pencarian kandidat wajah, seleksi ambiguitas (margin >= 0.05), validasi keaktifan member, dan anti-duplicate cooldown 60s."],
    ["routes.py", "REST API", "Seluruh rute HTTP endpoint: /checkin, /recognize, /enrollments/start, /enrollments/samples, /streaming/analyze, dan /devices."],
    ["main.py", "Entrypoint", "Inisialisasi aplikasi FastAPI, middleware CORS (izin akses Laravel), exception handlers, dan startup healthcheck model."],
    ["config.py", "Konfigurasi", "Konfigurasi Pydantic Settings: path model ONNX, hash SHA-256, threshold blur (80), exposure (45-210), match threshold (0.50), dan kunci JWT."],
    ["models.py", "ORM Database", "Skema tabel SQLAlchemy: Member, FaceProfile (vektor 128 float), FaceSample, Device kiosk, CheckinAttempt, dan SystemSetting."],
    ["database.py", "Database Engine", "Inisialisasi koneksi SQLAlchemy ke database SQLite (gym.db) dan helper waktu UTC."],
    ["schemas.py", "Data Validation", "Skema Pydantic DTO untuk memvalidasi format JSON request dan response pada setiap rute."],
    ["security.py", "Kriptografi", "Hashing password akun API menggunakan bcrypt, pembuatan token JWT, dan verifikasi API key perangkat kiosk."],
    ["deps.py", "Dependencies", "Dependency injection FastAPI: get_db, get_current_user, get_face_engine, dan get_current_device."],
    ["memberships.py", "Validasi Bisnis", "Pemeriksaan apakah status keanggotaan member masih aktif saat wajahnya dikenali oleh AI."],
    ["rate_limit.py", "Keamanan Jaringan", "Token-bucket rate limiter untuk membatasi frekuensi request kamera guna mencegah spam/overload."],
    ["download_models.py", "Utilitas Model", "Skrip pengunduh otomatis model ONNX resmi dari OpenCV Zoo GitHub dengan validasi hash SHA-256."],
    ["audit.py", "Audit Logging", "Pencatatan riwayat audit operasional perangkat dan perubahan konfigurasi sistem biometrik."],
    ["errors.py", "Error Handling", "Format error JSON terstandarisasi (misal: NO_FACE, IMAGE_TOO_BLURRY, FACE_TOO_SMALL)."],
    ["seed.py", "Database Seeding", "Pengisian data awal database (cabang default GYM-001 dan akun superadmin API)."],
]
t_app = Table(app_files, colWidths=[3.5*cm, 3.2*cm, 9.8*cm])
t_app.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), DARK_BLUE),
    ("TEXTCOLOR", (0,0), (-1,0), WHITE),
    ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"),
    ("FONTSIZE", (0,0), (-1,-1), 7.5),
    ("ROWBACKGROUNDS", (0,1), (-1,-1), [WHITE, GRAY_BG]),
    ("GRID", (0,0), (-1,-1), 0.5, BORDER_CLR),
    ("TOPPADDING", (0,0), (-1,-1), 3),
    ("BOTTOMPADDING", (0,0), (-1,-1), 3),
    ("LEFTPADDING", (0,0), (-1,-1), 5),
    ("FONTNAME", (0,1), (0,-1), "Courier"),
]))
story.append(t_app)

story.append(Spacer(1, 4))
story.append(Paragraph("7.3 File Konfigurasi & Basis Data Root (bisagym-api/)", h2_style))
root_files = [
    ["File / Folder", "Jenis", "Fungsi dan Keterangan"],
    ["gym.db", "Database SQLite", "Basis data lokal tempat tersimpannya vektor wajah 128-dimensi member, data perangkat kiosk, dan log presensi."],
    [".env / .env.example", "Environment", "Konfigurasi lokal port API (8001), URL database SQLite, dan kredensial JWT."],
    ["pyproject.toml", "Dependencies", "Daftar pustaka Python yang dibutuhkan (FastAPI, OpenCV 4.13, NumPy, SQLAlchemy, Pydantic, Uvicorn)."],
    ["alembic.ini & migrations/", "Migrasi DB", "Konfigurasi dan riwayat migrasi skema tabel database SQLite."],
    [".venv/", "Virtual Environment", "Lingkungan Python 3.13 terisolasi berisi seluruh binary library C++ (OpenCV)."],
    ["tests/", "Unit Testing", "Kumpulan test case otomatis untuk menguji keakuratan deteksi wajah, kualitas gambar, dan presensi."],
]
t_root = Table(root_files, colWidths=[4.2*cm, 3.2*cm, 9.1*cm])
t_root.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), colors.HexColor("#7c2d12")),
    ("TEXTCOLOR", (0,0), (-1,0), WHITE),
    ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"),
    ("FONTSIZE", (0,0), (-1,-1), 7.5),
    ("ROWBACKGROUNDS", (0,1), (-1,-1), [WHITE, colors.HexColor("#fef2f2")]),
    ("GRID", (0,0), (-1,-1), 0.5, BORDER_CLR),
    ("TOPPADDING", (0,0), (-1,-1), 3),
    ("BOTTOMPADDING", (0,0), (-1,-1), 3),
    ("LEFTPADDING", (0,0), (-1,-1), 5),
    ("FONTNAME", (0,1), (0,-1), "Courier"),
]))
story.append(t_root)

story.append(Spacer(1, 10))

# PENUTUP
penutup_data = [
    [Paragraph("<b>Kesimpulan Teknis</b>", make_style("PHead", fontSize=10, textColor=WHITE, fontName="Helvetica-Bold", alignment=TA_CENTER))],
    [Paragraph(
        "Arsitektur modular pada folder <i>bisagym-api</i> memisahkan dengan tegas antara engine komputasi AI biometrik "
        "dengan aplikasi bisnis Laravel. Pemrosesan citra digital (Variansi Laplacian, Histogram Exposure, Size Normalization) "
        "yang diimplementasikan di <i>biometrics.py</i> memastikan hanya citra bermutu tinggi yang diumpankan ke model YuNet dan SFace. "
        "Hasil ekstraksi berupa vektor 128-dimensi yang dinormalisasi L2 memungkinkan pencocokan presensi berbasis Cosine Similarity "
        "dieksekusi dalam hitungan milidetik di level CPU dengan efisiensi memori yang optimal.",
        make_style("PBody", fontSize=8.5, leading=13, textColor=colors.HexColor("#dbeafe"), alignment=TA_JUSTIFY, fontName="Helvetica")
    )],
    [Paragraph("Website BisaGym · Dokumentasi AI, Citra & Arsitektur File · November 2026", make_style("PFoot", fontSize=7.5, textColor=colors.HexColor("#93c5fd"), alignment=TA_CENTER, fontName="Helvetica"))]
]
penutup_table = Table(penutup_data, colWidths=[16.5*cm])
penutup_table.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,-1), DARK_BLUE),
    ("TOPPADDING", (0,0), (-1,-1), 8),
    ("BOTTOMPADDING", (0,0), (-1,-1), 8),
    ("LEFTPADDING", (0,0), (-1,-1), 12),
    ("RIGHTPADDING", (0,0), (-1,-1), 12),
    ("ROUNDEDCORNERS", [6,6,6,6]),
]))
story.append(penutup_table)

doc.build(story)
print(f"PDF dibuat: {OUTPUT_PROJECT}")
