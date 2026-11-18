@echo off
setlocal
title Druckerwarteschlange neu starten

rem --- Administratorrechte pruefen, sonst Skript mit UAC-Abfrage neu starten ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Fordere Administratorrechte an...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo Stoppe Druckerwarteschlange (Spooler)...
net stop spooler /y >nul 2>&1

rem Kurz warten, bis der Dienst wirklich beendet ist
timeout /t 2 /nobreak >nul

echo Starte Druckerwarteschlange...
net start spooler >nul 2>&1

sc query spooler | find "RUNNING" >nul
if %errorlevel% equ 0 (
    echo.
    echo [OK] Die Druckerwarteschlange wurde erfolgreich neu gestartet.
) else (
    echo.
    echo [FEHLER] Die Druckerwarteschlange laeuft nicht. Bitte manuell pruefen ^(services.msc^).
)

echo.
echo Fenster schliesst in 5 Sekunden...
timeout /t 5 >nul
endlocal
