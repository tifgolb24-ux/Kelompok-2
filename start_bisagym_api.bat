@echo off
title BisaGym AI Biometrics API (Port 8001)
echo ===================================================
echo   Menjalankan BisaGym Face Biometrics Service
echo ===================================================
cd /d "D:\Projek_Web\laragon\www\PBL\Website-BisaGym\bisagym-api"
.\.venv\Scripts\python.exe -m uvicorn app.main:app --host 0.0.0.0 --port 8001
pause
