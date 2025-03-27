#Requires -RunAsAdministrator

Import-Module -Name './common.psm1'

function Install-Base {
  WSReset.exe -i
  Install-PackageProvider -Name 'NuGet' -Force
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

  Install-Module -Name Microsoft.WinGet.Client -Force -AllowClobber
  Repair-WinGetPackageManager -Latest -Force

  Update-Module -Force
  winget upgrade --source winget --all

  @(
    'OpenSSH.Client',
    'OpenSSH.Server'
  ) | ForEach-Object -Process { Add-WindowsCapability -Online -Name "$_" }

  Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName @(
    'HypervisorPlatform',
    'VirtualMachinePlatform',
    'Microsoft-Hyper-V',
    'Microsoft-Windows-Subsystem-Linux',
    'Containers-DisposableClientVM'
  )

  @(
    'XPFP7F8RL7MB1W',
    'XPDC2RH70K22MN',
    '9NBLGGH516XP',
    'XP8LFCZM790F6B',
    'XPDCCPPSK2XPQW',
    '9PLJWWSV01LK',
    '9P95ZZKTNRN4',
    'XP89DCGQ3K6VLD'
  ) | ForEach-Object -Process {
    winget install --accept-source-agreements --accept-package-agreements --source msstore --id "$_"
  }

  @(
    'AdGuard.AdGuard',
    'AdGuard.AdGuardVPN',
    'Bitwarden.Bitwarden',
    'voidtools.Everything',
    'Git.Git',
    'Google.GoogleDrive',
    'jftuga.less',
    'Microsoft.OneDrive',
    'Neovim.Neovim',
    'Valve.Steam',
    'StartIsBack.StartAllBack'
    'CodeSector.TeraCopy',
    'Google.QuickShare',
    'RedHat.Podman',
    'RedHat.Podman-Desktop'
  ) | ForEach-Object -Process {
    winget install --accept-source-agreements --accept-package-agreements --source winget --id "$_"
  }
}

function Install-Shell {
  winget install --source winget --id 'Microsoft.PowerShell'

  Install-Module -Scope CurrentUser -Force -AllowClobber -Name @(
    'PowerShellGet',
    'PSReadLine',
    'posh-git'
  )
}

function Install-Prompt {
  winget install --source winget --id 'Starship.Starship'
}

function main {
  $ErrorActionPreference = 'SilentlyContinue'

  Install-Base
  Install-Shell
  Install-Prompt

  Set-Base
  Set-Shell
  Set-Prompt
  Set-RunCom
}

main
