@echo off
chcp 65001 > nul
echo ============================================
echo   BisaGym AI API - Auto Start
echo   Website: https://fitfacely.com
echo ============================================
echo.

echo [1/3] Memulai bisagym-api Python...
start "BisaGym API - uvicorn" powershell -NoExit -Command "cd 'D:\Projek_Web\laragon\www\PBL\Website-BisaGym\bisagym-api'; .venv\Scripts\Activate.ps1; uvicorn app.main:app --host 0.0.0.0 --port 8001"

echo Menunggu API siap (5 detik)...
timeout /t 5 /nobreak > nul

echo [2/3] Memulai Ngrok tunnel (port 8001)...
start "BisaGym Ngrok Tunnel" powershell -NoExit -Command "C:\ngrok\ngrok.exe http 8001"

echo Menunggu ngrok siap (3 detik)...
timeout /t 3 /nobreak > nul

echo [3/3] Membuka Ngrok dashboard di browser...
start http://127.0.0.1:4040

echo.
echo ============================================
echo   LANGKAH SELANJUTNYA:
echo   1. Lihat URL ngrok di tab browser yang baru terbuka
echo      (atau di http://127.0.0.1:4040)
echo   2. Copy URL https://xxxx.ngrok-free.app
echo   3. Login cPanel Niagahoster ^> File Manager
echo   4. Edit .env ^> ubah BISAGYM_FACE_API_URL=URL_NGROK
echo   5. Jalankan: php artisan config:clear di server
echo   6. Test: https://URL_NGROK/health
echo ============================================
echo.
echo Tekan tombol apa saja untuk menutup jendela ini...
echo (Jangan tutup jendela PowerShell yang sudah terbuka!)
pause > nul
