@echo off

:: Precheck
fltmc >nul || exit /b

:: Set paths
set SETUPDIR=%SystemRoot%\Setup
set ASSETSDIR=%SETUPDIR%\Assets
set SCRIPTSDIR=%SETUPDIR%\Scripts

:: 7-Zip
"%ASSETSDIR%\7z-x64.exe" /S

:: Office
:: In start_setup.cmd, use start -wait setup.exe
:: In configure.xml, use <Display Level="None" AcceptEULA="Yes" />
start /wait cmd /c "%ASSETSDIR%\Office\start_setup.cmd"

::
curl -SL -o "%SCRIPTSDIR%\MAS_AIO.cmd" https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd
start /wait cmd /c "%SCRIPTSDIR%\MAS_AIO.cmd" /HWID /Ohook

:: Clean up
if exist "%SETUPDIR%\CreateSetup.cmd" @rd /S /Q "%SETUPDIR%\CreateSetup.cmd"
if exist "%ASSETSDIR%" @rd /S /Q "%ASSETSDIR%"
if exist "%SCRIPTSDIR%" @rd /S /Q "%SCRIPTSDIR%"
exit /b
