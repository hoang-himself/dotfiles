set SETUPDIR=%SystemRoot%\Setup
set ASSETSDIR=%TEMP%\Assets
set SCRIPTSDIR=%SETUPDIR%\Scripts

:: MSI installs might require a writeable folder
xcopy /HIVERKYQ %SETUPDIR%\* %TEMP%\

:: ScriptBlock Logging
powershell.exe -Command "try { Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -ErrorAction Stop | Out-Null } catch {}"
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /f
reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v EnableScriptBlockLogging /t REG_DWORD /d 1 /f

:: Speed up MSI installs
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 0 /f
CiTool.exe --refresh --json >nul 2>&1

:: Explorer tweaks
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v UseCompactMode /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Software\Microsoft\Clipboard" /v EnableClipboardHistory /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Control Panel\Accessibility\Keyboard Preference" /v On /t REG_SZ /d 1 /f
reg.exe add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 63 /f

:: Apply changes
powershell.exe -Command "Stop-Process -Name explorer -Force;"
powershell.exe -Command "Start-Process explorer.exe %ASSETSDIR%;"

:: Install applications
start "" powershell.exe -NoProfile -Command "Add-AppxPackage -Path %ASSETSDIR%\40174MouriNaruto.NanaZip_gnj4mf6z9tkrc.msixbundle;"

:: https://github.com/microsoft/vscode/blob/main/build/win32/code.iss
start "" "%ASSETSDIR%\VSCodeUserSetup-x64.exe" /SILENT /SUPPRESSMSGBOXES /MERGETASKS="!runcode,desktopicon,quicklaunchicon,addcontextmenufiles,addcontextmenufolders,addtopath"

::start "" "%ASSETSDIR%\wireguard-installer.exe" /S
