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
goto install_vcredist
curl.exe -SL --connect-timeout 10 -o "%ASSETSDIR%\VisualCppRedist_AIO_x86_x64.exe" https://github.com/abbodi1406/vcredist/releases/latest/download/VisualCppRedist_AIO_x86_x64.exe
:install_vcredist
"%ASSETSDIR%\VisualCppRedist_AIO_x86_x64.exe" /ai9 >> "%LOGFILE%" 2>&1

::
echo Installing WinGet... >> "%LOGFILE%" 2>&1
goto install_winget
curl.exe -SL --connect-timeout 10 -o "%ASSETSDIR%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
:install_winget
powershell.exe -NoProfile -Command "Add-AppxPackage -Path %ASSETSDIR%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle;" >> "%LOGFILE%" 2>&1

::
echo Installing NanaZip... >> "%LOGFILE%" 2>&1
goto install_nanazip
curl.exe -SL --connect-timeout 10 -H "User-Agent: Wget x64" -o "%ASSETSDIR%\NanaZip.msixbundle" https://sourceforge.net/projects/nanazip/files/latest/download
:install_nanazip
powershell.exe -NoProfile -Command "Add-AppxPackage -Path '%ASSETSDIR%\NanaZip.msixbundle';" >> "%LOGFILE%" 2>&1

::
echo Installing Office... >> "%LOGFILE%" 2>&1
goto install_o365
curl.exe -SL --connect-timeout 10 -o "%ASSETSDIR%\setup.exe" https://officecdn.microsoft.com/pr/wsus/setup.exe
"%ASSETSDIR%\Office\setup.exe" /download "%ASSETSDIR%\Office\O365ProPlusRetail.xml"
:install_o365
"%ASSETSDIR%\Office\setup.exe" /configure "%ASSETSDIR%\Office\O365ProPlusRetail.xml" >> "%LOGFILE%" 2>&1

::
echo Running Microsoft Activation Scripts... >> "%LOGFILE%" 2>&1
goto install_mas
curl.exe -SL --connect-timeout 10 -o "%SCRIPTSDIR%\MAS_AIO.cmd" https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version-KL/MAS_AIO.cmd
:install_mas
start /wait cmd /c "%SCRIPTSDIR%\MAS_AIO.cmd" /HWID /Ohook >> "%LOGFILE%" 2>&1

::
echo SetupComplete.cmd finished successfully. Running cleanup... >> "%LOGFILE%" 2>&1

if exist "%SETUPDIR%\CreateSetup.cmd" del /Q "%SETUPDIR%\CreateSetup.cmd"
if exist "%ASSETSDIR%" rd /S /Q "%ASSETSDIR%"
for /f "delims=" %%i in ('dir "%SCRIPTSDIR%" /b /a-d ^| findstr /vile ".log" ^| findstr /vile "UserOnce.ps1"') do del "%SCRIPTSDIR%\%%i"

::
echo ==================== SetupComplete.cmd Ended: %date% %time% ==================== >> "%LOGFILE%" 2>&1
exit /b
