echo 1
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion


for /f "tokens=2*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul ^| find "Desktop"') do set "DESKTOP_DIR=%%b"

if not defined DESKTOP_DIR (
    if exist "%USERPROFILE%\Desktop" (
        set "DESKTOP_DIR=%USERPROFILE%\Desktop"
    ) else if exist "%USERPROFILE%\OneDrive\Desktop" (
        set "DESKTOP_DIR=%USERPROFILE%\OneDrive\Desktop"
    ) else (
        set "DESKTOP_DIR=%USERPROFILE%\Desktop"
    )
)

set "target_x64=%ProgramFiles%\1cv8"
set "count_x64=0"
set "has_x64=false"

if exist "%target_x64%" (
    for /f %%A in ('dir "%target_x64%" /ad /b 2^>nul ^| find /c /v ""') do set count_x64=%%A
    if !count_x64! geq 1 (
        set has_x64=true
    )
)


if "!has_x64!"=="true" (
	set "TARGET_FILE=%DESKTOP_DIR%\Sancity\Sancity-Updater-x64.exe"
	set "URL=https://raw.githubusercontent.com/Dan4oby/Sancity-Service/refs/heads/main/Sancity_Updater-x64.exe"
) else (
	set "TARGET_FILE=%DESKTOP_DIR%\Sancity\Sancity-Updater-x86.exe"
	set "URL=https://raw.githubusercontent.com/Dan4oby/Sancity-Service/refs/heads/main/Sancity_Updater-x86.exe"
)


mkdir "%DESKTOP_DIR%\Sancity"

del /Q %TARGET_FILE%
set "SUCCESS=0"

curl -L -o "!TARGET_FILE!" "!URL!"

if %errorlevel% equ 0 (
    if exist "!TARGET_FILE!" (
        set "SUCCESS=1"
    )
)

if !SUCCESS! equ 0 (
    powershell -ExecutionPolicy Bypass -Command "& { try { [System.Net.ServicePointManager]::SecurityProtocol = [Enum]::ToObject([Net.SecurityProtocolType], 3072); $wc = New-Object System.Net.WebClient; $wc.DownloadFile('%URL%', '%TARGET_FILE%'); if (Test-Path '%TARGET_FILE%') { exit 0 } else { exit 1 } } catch { exit 1 } }"
    
    if !errorlevel! equ 0 (
		if exist "!TARGET_FILE!" (
			set "SUCCESS=1"
		)
    )
)

if !SUCCESS! equ 0 (
    bitsadmin /transfer myJob /download /priority high "%URL%" "%TARGET_FILE%"
    
    if !errorlevel! equ 0 (
		if exist "!TARGET_FILE!" (
			set "SUCCESS=1"
		)
    )
)

if !SUCCESS! equ 1 (
    explorer /select,"%TARGET_FILE%"
) else (
    echo FAIL
    pause
)

:end
del /Q %TEMP%\*.bat