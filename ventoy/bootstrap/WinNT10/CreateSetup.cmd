:: Set paths
set USBPART=%~d0
set FILEDIR=%USBPART%\bootstrap\WinNT10
set SETUPDIR=%WINDIR%\Setup
set ASSETSDIR=%SETUPDIR%\Assets

:: Copy files to local
xcopy /HIVERKY "%FILEDIR%\*.*" "%SETUPDIR%\" 2>&1
if not exist "%ASSETSDIR%" mkdir "%ASSETSDIR%"
