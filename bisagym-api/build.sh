#!/usr/bin/env bash
# build.sh - Script build untuk Render.com
# Dijalankan saat deploy: install deps + download model AI

set -e

echo "=== [1/3] Install Python dependencies ==="
pip install --upgrade pip
pip install -e ".[dev]" 2>/dev/null || pip install -e .

echo "=== [2/3] Download model AI (OpenCV SFace + YuNet) ==="
python -m app.download_models

echo "=== [3/3] Build selesai! ==="
echo "Models siap di: runtime-models/"
ls -lh runtime-models/
