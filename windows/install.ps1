function Assert-Elevated {
  # Get the ID and security principal of the current user account
  $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $MyPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyIdentity)
  # Check to see if we are currently running "as Administrator"
  return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Self elevate administrative permissions in this script
if (-not (Assert-Elevated)) {
  Start-Process pwsh "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb 'RunAs'
  exit
}

#----------#
function Uninstall-Bloat {
  # Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
  @(
    'king.com.CandyCrushFriends',
    'Microsoft.3DBuilder',
    'Microsoft.Print3D',
    'Microsoft.BingNews',
    'Microsoft.OneConnect',
    'Microsoft.Microsoft3DViewer',
    'HolographicFirstRun',
    'Microsoft.MixedReality.Portal'
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.Getstarted',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.XboxApp',
    'Fitbit.FitbitCoach',
    '4DF9E0F8.Netflix'
  ) | ForEach-Object {
    Get-AppxPackage -Name $_ | Remove-AppxPackage
  }
}

function Install-BasePackage {
  Update-Module -Force
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
  Get-PackageProvider | Where-Object -Property Name -EQ 'NuGet' | Install-PackageProvider -Force
  @(
    'PowerShellGet',
    'PSReadLine',
    'PSScriptAnalyzer'
  ) | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser -Force
  }
  Update-Help -Force
}

function Install-OMP {
  @(
    'posh-git',
    'oh-my-posh',
    'Terminal-Icons'
  ) | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser -Force
  }

  # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
  Get-ChildItem -Path '.\runcoms\*' -Include '*.ps1' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$env:ProfileDir\$($_.Name)" `
        -Target $_.FullName -Force
    }
  Get-ChildItem -Path '.\runcoms\plugins\' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$env:PluginsDir\$($_.Name)" `
        -Target $_.FullName -Force
    }
}

function Install-Pyenv {
  $python_target = '3.10.4'
  git clone --depth=1 'https://github.com/pyenv-win/pyenv-win.git' "$env:USERPROFILE\.pyenv"

  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'
  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV_ROOT' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'
  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV_HOME' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'

  $raw_hkcu_path = (Get-Item -Path 'HKCU:\Environment').GetValue(
    'Path', # the registry-value name
    $null, # the default value to return if no such value exists.
    'DoNotExpandEnvironmentNames' # the option that suppresses expansion
  )
  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' `
    -Value $('%USERPROFILE%\.pyenv\pyenv-win\bin;%USERPROFILE%\.pyenv\pyenv-win\shims;' `
      + $raw_hkcu_path)

  $env:PYENV_ROOT = "$HOME/.pyenv"
  $env:Path = "$PYENV_ROOT/bin:$Path"

  pyenv update
  pyenv install -q "$python_target"
  pyenv global "$python_target"
  pip install --upgrade pip setuptools wheel
}

function Install-OpenSSH {
  # https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
  Add-WindowsCapability -Online -Name OpenSSH.Client
  Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service

  Add-WindowsCapability -Online -Name OpenSSH.Server
  Get-Service sshd | Set-Service -StartupType Automatic -PassThru | Start-Service

  # Confirm the Firewall rule is configured. It should be created automatically by setup
  if (-not (Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
  }

  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.ssh\config" `
    -Target $(Resolve-Path -LiteralPath .\configs\openssh\ssh_config) -Force
  New-Item -ItemType Directory -Path "$env:ProgramData\ssh\keys\$env:USERNAME" -Force
  # icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
  New-Item -ItemType SymbolicLink -Path "$env:ProgramData\ssh\sshd_config" `
    -Target $(Resolve-Path -LiteralPath .\configs\openssh\sshd_config) -Force
  New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -PropertyType String `
    -Name DefaultShell -Value 'C:\Program Files\PowerShell\7\pwsh.exe' -Force
}

function Install-WSL {
  # Get-WindowsOptionalFeature -Online
  Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName `
  @('VirtualMachinePlatform', 'Microsoft-Windows-Subsystem-Linux') | Out-Null

  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.wslconfig" `
    -Target $(Resolve-Path -LiteralPath .\configs\wslconfig) -Force
}

function Install-Config {
  Get-ChildItem -Path '.\configs\git\' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$env:ProfileDir\.$($_.Name)" `
        -Target $_.FullName -Force
    }
  # Add-Content "$env:ProfileDir\.gitconfig.local" $null

  Get-ChildItem -Path '.\configs\gnupg\' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$env:ProfileDir\.gnupg\$($_.Name)" `
        -Target $_.FullName -Force
    }
}

function main {
  $env:ProfileDir = Split-Path -Parent $Profile
  $env:PluginsDir = Join-Path $env:ProfileDir 'plugins'
  New-Item -Path $env:ProfileDir -ItemType Directory -ErrorAction SilentlyContinue -Force
  New-Item -Path $env:PluginsDir -ItemType Directory -ErrorAction SilentlyContinue -Force

  #Uninstall-Bloat
  Install-BasePackage
  Install-OMP
  Install-Pyenv
  Install-OpenSSH
  Install-WSL
  Install-Config

  Remove-Item -Path 'Env:ProfileDir'
  Remove-Item -Path 'Env:PluginsDir'
}

# TODO Use while and switch case
if ($args[0] -eq '-i' || $args[0] -eq '--install') {
  main
}
else {
  Write-Output "Unrecognized option $($args[0])"
}
