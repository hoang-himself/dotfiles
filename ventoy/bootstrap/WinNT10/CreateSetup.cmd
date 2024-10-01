:: Set paths
set USBPART=%~d0
set FILEDIR=%USBPART%\bootstrap\WinNT10
set SETUPDIR=%WINDIR%\Setup
set ASSETSDIR=%SETUPDIR%\Assets

:: Copy files to local
xcopy /H /I /V /E /R/ K /Y "%FILEDIR%\*.*" "%SETUPDIR%\" >nul
if not exist "%ASSETSDIR%" mkdir "%ASSETSDIR%"
