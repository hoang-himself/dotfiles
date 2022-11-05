set SETUPDIR=C:\Users\WDAGUtilityAccount\Desktop\Setup
set ASSETSDIR=%TEMP%\Assets

:: We need a writeable location to launch MSIs for some reason
xcopy /HIVERKYQ %SETUPDIR%\* %TEMP%\

::
"%ASSETSDIR%\7zip-installer.exe" /S
:: https://github.com/microsoft/vscode/blob/main/build/win32/code.iss
"%ASSETSDIR%\vscode-installer.exe" /SILENT /SUPPRESSMSGBOXES /MERGETASKS="!runcode,desktopicon,quicklaunchicon,addcontextmenufiles,addcontextmenufolders,addtopath"
"%ASSETSDIR%\wireguard-installer.exe" /S

:: PowerShell script block logging
powershell.exe -Command "New-Item -Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force"
powershell.exe -Command "Set-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Value 1 -Force"
