@echo off
chcp 65001 >nul
title BatteryGuard AI
cd /d "%~dp0"
echo Iniciando BatteryGuard AI...
echo (La primera vez instala las dependencias)
python -m pip install -q -r requirements.txt
if not exist .env copy .env.example .env >nul
python server.py
pause
