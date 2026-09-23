#!/bin/bash
# Startup script for FastAPI backend server
cd "$(dirname "$0")"

echo "=========================================="
echo "Starting AI-Based Travel Assistant Backend"
echo "=========================================="

python3 -m pip install -r requirements.txt --break-system-packages -q 2>/dev/null || python3 -m pip install -r requirements.txt -q

echo "Launching FastAPI Uvicorn Server on http://localhost:8000 ..."
python3 -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
