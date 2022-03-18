# Self elevate administrative permissions in this script
if (!(Assert-Elevated)) {
  Start-Process pwsh '-NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath"' -Verb 'RunAs'
  exit
}

Import-Module -Name .\common.psm1

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
  @(
    'PowerShellGet',
    'PSReadLine'
  ) | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser -Force
  }

  Install-OpenSSH
  Install-OMP
  Install-WSL
}

function Install-Configs {
  $ProfileDir = Split-Path -Parent $Profile
  $PluginsDir = Join-Path $ProfileDir 'plugins'
  New-Item -Path $ProfileDir -ItemType Directory -ErrorAction SilentlyContinue -Force
  New-Item -Path $PluginsDir -ItemType Directory -ErrorAction SilentlyContinue -Force

  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.ssh\config" `
    -Target $(Resolve-Path -LiteralPath .\configs\ssh_config) -Force
  # icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
  New-Item -ItemType SymbolicLink -Path "$env:ProgramData\ssh\sshd_config" `
    -Target $(Resolve-Path -LiteralPath .\configs\sshd_config) -Force
  New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -PropertyType String `
    -Name DefaultShell -Value 'C:\Program Files\PowerShell\7\pwsh.exe' -Force
  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.wslconfig" `
    -Target $(Resolve-Path -LiteralPath .\configs\wslconfig) -Force

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

  Get-ChildItem -Path '.\configs\git\' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.$($_.Name)" `
        -Target $_.FullName -Force
    }
  Add-Content "$env:USERPROFILE\.gitconfig.local" $null

  Get-ChildItem -Path '.\configs\gnupg\' |
    ForEach-Object {
      New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gnupg\$($_.Name)" -Target $_.FullName -Force
    }
}

function main {
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
  Update-Upgrade
  Install-Packages
  Install-Configs
}

main
