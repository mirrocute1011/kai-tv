@echo off
title Kai TV
echo Starting Kai TV local server...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1"
echo.
echo Server stopped. If there is a red error above, please screenshot it for Claude.
pause
