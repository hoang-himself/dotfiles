@echo off

:: Set paths
set USBPART=%~d0
set FILEDIR=%USBPART%\bootstrap\WinNT10
set SETUPDIR=%WINDIR%\Setup
set ASSETSDIR=%SETUPDIR%\Assets

:: Copy files to local
xcopy /HIVERKYQ "%FILEDIR%\*.*" "%SETUPDIR%\" 2>&1
