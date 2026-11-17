@echo off
title BisaGym Launcher
echo =======================================================
echo  Memulai BisaGym Full Stack:
echo  1. Laravel Web Server    - http://127.0.0.1:8000
echo  2. Biometric API Service - http://127.0.0.1:8001
echo =======================================================

start "BisaGym Biometric API (Port 8001)" cmd /c "cd /d "%~dp0bisagym-api" && .\.venv\Scripts\python.exe -m uvicorn app.main:app --host 0.0.0.0 --port 8001"
start "BisaGym Laravel (Port 8000)" cmd /c "cd /d "%~dp0" && php artisan serve --host=127.0.0.1 --port=8000"

echo Layanan sedang berjalan di jendela terpisah.
echo Buka browser di http://127.0.0.1:8000

