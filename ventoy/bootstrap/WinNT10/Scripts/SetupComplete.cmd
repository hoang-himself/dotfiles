@echo off

:: Precondition
fltmc >nul || exit /b

:: Set paths
set SETUPDIR=%SystemRoot%\Setup
set ASSETSDIR=%SETUPDIR%\Assets
set SCRIPTSDIR=%SETUPDIR%\Scripts

:: Office
::start /wait cmd /c "%ASSETSDIR%\Office\start_setup.cmd"

:: MAS
::curl -SL -o "%SCRIPTSDIR%\MAS_AIO.cmd" https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version-KL/MAS_AIO.cmd
::start /wait cmd /c "%SCRIPTSDIR%\MAS_AIO.cmd" /HWID /Ohook

:: Visual C++ Redistributable
::curl -SL -o "%ASSETSDIR%\VisualCppRedist_AIO_x86_x64.exe" https://github.com/abbodi1406/vcredist/releases/latest/download/VisualCppRedist_AIO_x86_x64.exe
::"%ASSETSDIR%\VisualCppRedist_AIO_x86_x64.exe" /ai9

:: WinGet
::curl -SL -o "%ASSETSDIR%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
::powershell.exe -NoProfile -Command "Add-AppxPackage -Path %ASSETSDIR%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle;"

:: 7-Zip
::curl -H "User-Agent: Wget x64" -SL -o "%ASSETSDIR%\7z-x64.exe" https://sourceforge.net/projects/sevenzip/files/latest/download
::"%ASSETSDIR%\7z-x64.exe" /S

:: Postcondition
if exist "%SETUPDIR%\CreateSetup.cmd" del /Q "%SETUPDIR%\CreateSetup.cmd"
if exist "%ASSETSDIR%" rd /S /Q "%ASSETSDIR%"
for /f "delims=" %%i in ('dir "%SCRIPTSDIR%" /b /a-d ^| findstr /vile ".log" ^| findstr /vile "UserOnce.ps1"') do del "%SCRIPTSDIR%\%%i"
exit /b
