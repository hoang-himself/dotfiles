@echo off

:: Set paths
set USB=%~d0
set FILEDIR=%USB%\bootstrap\WinNT10\
set SETUPDIR=%WINDIR%\Setup\
set ASSETSDIR=%SETUPDIR%\Assets\

:: Copy files to local
xcopy /herky "%FILEDIR%\*.*" "%SETUPDIR%\" >nul
if not exist "%ASSETSDIR%" mkdir "%ASSETSDIR%"
