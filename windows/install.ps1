Import-Module -Name .\common.psm1

# Self elevate administrative permissions in this script
if ( -not (Assert-Elevated)) {
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
}

function main {
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
  Install-Packages
  Install-Configs
  Install-OpenSSH
  Install-OMP
  Install-WSL
}

main
