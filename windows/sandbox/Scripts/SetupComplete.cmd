set SETUPDIR=C:\Users\WDAGUtilityAccount\Desktop\Setup
set ASSETSDIR=%TEMP%\Assets

rem We need a writeable location to launch MSIs it seems
xcopy /H /I /V /E /R /K /Y %SETUPDIR%\* %TEMP%\

rem https://github.com/microsoft/vscode/blob/main/build/win32/code.iss
"%ASSETSDIR%\vscode.exe" /silent /suppressmsgboxes /MERGETASKS="!runcode,desktopicon,quicklaunchicon,addcontextmenufiles,addcontextmenufolders,addtopath"
"%ASSETSDIR%\7z-x64.exe" /S

rem PowerShell script block logging
powershell.exe -Command "New-Item -Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force"
powershell.exe -Command "Set-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Value 1 -Force"
