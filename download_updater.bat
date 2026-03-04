@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Определяем путь к рабочему столу через реестр
for /f "tokens=2*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul ^| find "Desktop"') do set "DESKTOP_DIR=%%b"

:: Если не удалось через реестр, пробуем стандартный путь
if not defined DESKTOP_DIR (
    if exist "%USERPROFILE%\Desktop" (
        set "DESKTOP_DIR=%USERPROFILE%\Desktop"
    ) else if exist "%USERPROFILE%\OneDrive\Desktop" (
        set "DESKTOP_DIR=%USERPROFILE%\OneDrive\Desktop"
    ) else (
        set "DESKTOP_DIR=%USERPROFILE%\Desktop"
    )
)

mkdir "%DESKTOP_DIR%\Sancity" 2>nul
set "TARGET_FILE=%DESKTOP_DIR%\Sancity\SanCity_Updater.exe"
set "SUCCESS=0"

echo 1/2 Download with curl...
curl -L -o "%TARGET_FILE%" "https://raw.githubusercontent.com/Dan4oby/Sancity-Service/refs/heads/main/SanCity_Updater.exe"

if %errorlevel% equ 0 (
    if exist "%TARGET_FILE%" (
        set "SUCCESS=1"
        echo [OK] File downloaded with curl.
    )
)

if !SUCCESS! equ 0 (
    echo 2/2 Download with PowerShell...
    
    powershell -ExecutionPolicy Bypass -Command "& {try { $webclient = New-Object System.Net.WebClient; $webclient.DownloadFile('https://raw.githubusercontent.com/Dan4oby/Sancity-Service/refs/heads/main/SanCity_Updater.exe', '%TARGET_FILE%'); if (Test-Path '%TARGET_FILE%') { exit 0 } else { exit 1 } } catch { exit 1 }}"
    
    if !errorlevel! equ 0 (
        set "SUCCESS=1"
        echo [OK] File downloaded with PowerShell.
    )
)

echo.
if !SUCCESS! equ 1 (
    echo [DONE] File saved to: %TARGET_FILE%
    explorer /select,"%TARGET_FILE%"
) else (
    echo [ERROR] Could not download file.
)

:end
pause