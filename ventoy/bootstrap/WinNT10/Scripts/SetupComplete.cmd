@echo off

:: Precheck
fltmc >nul || exit /b

:: Set paths
set SETUPDIR=%SystemRoot%\Setup\
set ASSETSDIR=%SETUPDIR%\Assets\

:: 7-Zip
"%ASSETSDIR%\7z-x64.exe" /S

:: Office
:: In start_setup.cmd, use start -wait setup.exe
:: In configure.xml, use <Display Level="None" AcceptEULA="Yes" />
start /wait cmd /c "%ASSETSDIR%\Office\start_setup.cmd"

::
start /wait cmd /c "%~dp0\MAS_AIO.cmd" /HWID /Ohook

:: Clean up
if exist "%SETUPDIR%\CreateSetup.cmd" @rd /S /Q "%SETUPDIR%\CreateSetup.cmd"
if exist "%ASSETSDIR%" @rd /S /Q "%ASSETSDIR%"
if exist "%SETUPDIR%\Scripts\" @rd /S /Q "%SETUPDIR%\Scripts\"
exit /b
