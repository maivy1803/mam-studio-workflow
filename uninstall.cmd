@echo off
rem Windows: go Mam_Studio_Kit (them -All de go ca bo nho va tai nguyen).
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1" %*
echo.
pause
