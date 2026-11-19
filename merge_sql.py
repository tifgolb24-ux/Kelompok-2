"""
Script untuk menggabungkan database_website_bisagym.sql (Laravel)
dengan tabel-tabel unik dari database_biometrics_citra.sql (AI/Python)
menjadi satu file: database_gabungan_bisagym.sql

Tabel biometrik yang dipakai (unik, tidak ada di Laravel):
  - audit_logs (AI audit, beda dengan activity_logs Laravel)
  - branches
  - devices
  - membership_plans  (beda dengan gym_packages Laravel)
  - auth_sessions
  - biometric_consents
  - enrollment_sessions
  - face_profiles
  - kiosk_sessions
  - memberships       (beda dengan member_transactions Laravel)
  - system_settings
  - checkin_attempts
  - face_enrollment_samples
  - access_events

Tabel biometrik yang DISKIP (sudah ada versi berbeda di Laravel):
  - members   -> Laravel punya versi sendiri dengan kolom berbeda
  - users     -> Laravel punya versi sendiri dengan kolom berbeda
"""

# Tabel dari biometrik yang akan diskip (sudah ada di Laravel dengan skema berbeda)
SKIP_BIO_TABLES = {'members', 'users'}

# Baca file Laravel (utama) - UTF-16 LE dengan BOM
with open('database_website_bisagym.sql', 'r', encoding='utf-16') as f:
    laravel_sql = f.read()

# Baca file biometrik - cek encoding
import codecs
raw_bio = open('database_biometrics_citra.sql', 'rb').read(4)
bio_enc = 'utf-16' if raw_bio[:2] in (b'\xff\xfe', b'\xfe\xff') else 'utf-8'
with open('database_biometrics_citra.sql', 'r', encoding=bio_enc) as f:
    bio_lines = f.readlines()

# Parse blok-blok dari biometrik SQL
# Format: CREATE TABLE IF NOT EXISTS nama_tabel (...);
# dan INSERT INTO `nama_tabel` ...;
import re

def extract_bio_blocks(lines):
    """
    Ekstrak blok CREATE TABLE dan INSERT yang bukan tabel duplikat.
    Return: string SQL bersih untuk ditambahkan
    """
    result = []
    i = 0
    current_table = None
    in_create = False
    block = []
    
    while i < len(lines):
        line = lines[i]
        
        # Deteksi CREATE TABLE IF NOT EXISTS
        m = re.match(r'CREATE TABLE IF NOT EXISTS (\w+)', line.strip())
        if m:
            current_table = m.group(1)
            in_create = True
            block = [line]
            i += 1
            # Kumpulkan sampai titik koma penutup tabel
            while i < len(lines):
                block.append(lines[i])
                if lines[i].strip() == ');':
                    break
                i += 1
            if current_table not in SKIP_BIO_TABLES:
                result.append('-- Tabel AI: ' + current_table + '\n')
                result.extend(block)
                result.append('\n')
            else:
                result.append(f'-- [SKIP] Tabel `{current_table}` sudah ada di Laravel (skema berbeda)\n\n')
            i += 1
            continue
        
        # Deteksi INSERT INTO
        m_insert = re.match(r'INSERT INTO `(\w+)`', line.strip())
        if m_insert:
            tbl = m_insert.group(1)
            if tbl not in SKIP_BIO_TABLES:
                # Kumpulkan seluruh INSERT (bisa multiline)
                insert_block = [line]
                while not line.rstrip().endswith(';') and i + 1 < len(lines):
                    i += 1
                    line = lines[i]
                    insert_block.append(line)
                result.extend(insert_block)
                result.append('\n')
            else:
                # Skip data untuk tabel duplikat
                while not line.rstrip().endswith(';') and i + 1 < len(lines):
                    i += 1
                    line = lines[i]
            i += 1
            continue
        
        # Lewati header dan SET statements dari biometrik (sudah ada di Laravel)
        if any(x in line for x in ['SET FOREIGN_KEY_CHECKS', '-- ===', '-- BisaGym', '-- Untuk diimport']):
            i += 1
            continue
        
        # Data komentar lain tetap diambil jika bukan tabel duplikat
        m_data = re.match(r'-- Data untuk tabel `(\w+)`', line.strip())
        if m_data:
            tbl = m_data.group(1)
            if tbl not in SKIP_BIO_TABLES:
                result.append(line)
            i += 1
            continue
        
        i += 1
    
    return ''.join(result)

bio_additional = extract_bio_blocks(bio_lines)

# Gabungkan
header = """-- =============================================================
-- BisaGym - Database Gabungan (Laravel + AI Biometrik)
-- File ini berisi SEMUA tabel untuk u777561646_bisagym
-- Import ke phpMyAdmin Niagahoster: pilih DB lalu klik Import
-- =============================================================

"""

separator = """

-- =============================================================
-- BAGIAN 2: TABEL AI BIOMETRIK (bisagym-api / Python FastAPI)
-- Tabel tambahan untuk fitur Face Recognition & Absensi Wajah
-- (members & users dari Laravel dipakai bersama)
-- =============================================================

SET FOREIGN_KEY_CHECKS = 0;

"""

footer = """

SET FOREIGN_KEY_CHECKS = 1;
"""

output = header + laravel_sql + separator + bio_additional + footer

with open('database_gabungan_bisagym.sql', 'w', encoding='utf-8', newline='\n') as f:
    f.write(output)

print("✅ Selesai! File: database_gabungan_bisagym.sql")
print(f"   - Ukuran: {len(output) / 1024:.1f} KB")
print(f"   - Laravel tables: diambil semua")
print(f"   - Biometrik tables: diambil (skip 'members' & 'users' duplikat)")
