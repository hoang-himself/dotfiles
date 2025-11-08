@echo off

::
set SETUPDIR=%SystemRoot%\Setup
set ASSETSDIR=%SETUPDIR%\Assets
set SCRIPTSDIR=%SETUPDIR%\Scripts
set LOGFILE=%SCRIPTSDIR%\SetupComplete.log

::
echo ==================== SetupComplete.cmd Started: %date% %time% ==================== >> "%LOGFILE%" 2>&1

::
fltmc.exe >nul || (echo Not running as administrator. Exiting... >> "%LOGFILE%" 2>&1 & exit /b)

::
echo Installing Visual C++ Redistributable... >> "%LOGFILE%" 2>&1
"%ASSETSDIR%\VisualCppRedist_AIO_x86_x64.exe" /ai9 >> "%LOGFILE%" 2>&1

::
echo Installing WinGet... >> "%LOGFILE%" 2>&1
powershell.exe -NoProfile -Command "Add-AppxPackage -Path %ASSETSDIR%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle;" >> "%LOGFILE%" 2>&1

::
echo Installing NanaZip... >> "%LOGFILE%" 2>&1
powershell.exe -NoProfile -Command "Add-AppxPackage -Path '%ASSETSDIR%\40174MouriNaruto.NanaZip_gnj4mf6z9tkrc.msixbundle';" >> "%LOGFILE%" 2>&1

::
echo Installing Office... >> "%LOGFILE%" 2>&1
"%ASSETSDIR%\Office\setup.exe" /configure "%ASSETSDIR%\Office\O365ProPlusRetail.xml" >> "%LOGFILE%" 2>&1

::
echo Running Microsoft Activation Scripts... >> "%LOGFILE%" 2>&1
start /wait cmd /c "%SCRIPTSDIR%\MAS_AIO.cmd" /HWID /Ohook >> "%LOGFILE%" 2>&1

::
echo SetupComplete.cmd finished successfully. Running cleanup... >> "%LOGFILE%" 2>&1

if exist "%SETUPDIR%\CreateSetup.cmd" del /Q "%SETUPDIR%\CreateSetup.cmd"
if exist "%SETUPDIR%\get-asset.ps1" del /Q "%SETUPDIR%\get-asset.ps1"
if exist "%ASSETSDIR%" rd /S /Q "%ASSETSDIR%"
for /f "delims=" %%i in ('dir "%SCRIPTSDIR%" /b /a-d ^| findstr /vile ".log" ^| findstr /vile "UserOnce.ps1"') do del "%SCRIPTSDIR%\%%i"

::
echo ==================== SetupComplete.cmd Ended: %date% %time% ==================== >> "%LOGFILE%" 2>&1
exit /b
