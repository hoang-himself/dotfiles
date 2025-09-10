set SETUPDIR=C:\Users\WDAGUtilityAccount\Desktop\Setup
set ASSETSDIR=%TEMP%\Assets

:: We need a writeable location to launch MSIs for some reason
xcopy /HIVERKYQ %SETUPDIR%\* %TEMP%\

::
start "" powershell.exe -NoProfile -Command "Add-AppxPackage -Path %ASSETSDIR%\NanaZip.msixbundle;"
:: https://github.com/microsoft/vscode/blob/main/build/win32/code.iss
start "" "%ASSETSDIR%\vscode-setup.exe" /SILENT /SUPPRESSMSGBOXES /MERGETASKS="!runcode,desktopicon,quicklaunchicon,addcontextmenufiles,addcontextmenufolders,addtopath"
::start "" "%ASSETSDIR%\wireguard-installer.exe" /S

:: PowerShell script block logging
powershell.exe -Command "New-Item -Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force"
powershell.exe -Command "Set-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Value 1 -Force"

::
powershell.exe -Command "Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0 -Force"
powershell.exe -Command "Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name UseCompactMode -Value 1 -Force"
