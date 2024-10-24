@echo off

:: Precondition
fltmc >nul || exit /b

:: Set paths
set SETUPDIR=%SystemRoot%\Setup
set ASSETSDIR=%SETUPDIR%\Assets
set SCRIPTSDIR=%SETUPDIR%\Scripts

:: 7-Zip
::curl -H "User-Agent: Wget x64" -SL -o "%ASSETSDIR%\7z-x64.exe" https://sourceforge.net/projects/sevenzip/files/latest/download
::"%ASSETSDIR%\7z-x64.exe" /S

:: Office
::start /wait cmd /c "%ASSETSDIR%\Office\start_setup.cmd"

::
::curl -SL -o "%SCRIPTSDIR%\MAS_AIO.cmd" https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version-KL/MAS_AIO.cmd
::start /wait cmd /c "%SCRIPTSDIR%\MAS_AIO.cmd" /HWID /Ohook

:: Postcondition
if exist "%SETUPDIR%\CreateSetup.cmd" del /Q "%SETUPDIR%\CreateSetup.cmd"
if exist "%ASSETSDIR%" rd /S /Q "%ASSETSDIR%"
::if exist "%SCRIPTSDIR%" rd /S /Q "%SCRIPTSDIR%"
exit /b
