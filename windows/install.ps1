Import-Module -Name .\common.psm1

# Self elevate administrative permissions in this script
if (-not (Assert-Elevated)) {
  Start-Process pwsh "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb 'RunAs'
  exit
}

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

function Install-Packages {
  Update-Help -Force
  Update-Module -Force

  @(
    'PowerShellGet',
    'PSReadLine'
  ) | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser -Force
  }
}

function Install-OMP {
  @(
    'oh-my-posh',
    'posh-git',
    'Terminal-Icons'
  ) | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser -Force
  }
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

  New-Item -ItemType Directory -Path "$env:ProgramData\ssh\keys\$env:USERNAME" -Force
}

function Install-WSL {
  # Get-WindowsOptionalFeature -Online
  Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName `
  @('VirtualMachinePlatform', 'Microsoft-Windows-Subsystem-Linux') | Out-Null
}

function Install-Configs {
  $ProfileDir = Split-Path -Parent $Profile
  $PluginsDir = Join-Path $ProfileDir 'plugins'

  New-Item -Path $ProfileDir -ItemType Directory -ErrorAction SilentlyContinue -Force
  New-Item -Path $PluginsDir -ItemType Directory -ErrorAction SilentlyContinue -Force

  Get-ChildItem -Path '.\configs\git\' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$ProfileDir\.$($_.Name)" `
        -Target $_.FullName -Force
    }
  Add-Content "$ProfileDir\.gitconfig.local" $null

  Get-ChildItem -Path '.\configs\gnupg\' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$ProfileDir\.gnupg\$($_.Name)" `
        -Target $_.FullName -Force
    }

  # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
  Get-ChildItem -Path '.\runcoms\*' -Include '*.ps1' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$ProfileDir\$($_.Name)" `
        -Target $_.FullName -Force
    }
  Get-ChildItem -Path '.\runcoms\plugins\' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$PluginsDir\$($_.Name)" `
        -Target $_.FullName -Force
    }

  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.ssh\config" `
    -Target $(Resolve-Path -LiteralPath .\configs\openssh\ssh_config) -Force
  # icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
  New-Item -ItemType SymbolicLink -Path "$env:ProgramData\ssh\sshd_config" `
    -Target $(Resolve-Path -LiteralPath .\configs\openssh\sshd_config) -Force
  New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -PropertyType String `
    -Name DefaultShell -Value 'C:\Program Files\PowerShell\7\pwsh.exe' -Force

  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.wslconfig" `
    -Target $(Resolve-Path -LiteralPath .\configs\wslconfig) -Force
}

function main {
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
  Install-Packages
  Install-OpenSSH
  Install-OMP
  Install-WSL
  Install-Configs
}

main
