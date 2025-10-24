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
    'XPFP7F8RL7MB1W', # Bing Wallpaper
    'XPDC2RH70K22MN', # Discord
    '9NBLGGH516XP', # EarTrumpet
    'XP8LFCZM790F6B', # Visual Studio Code - Insiders
    'XPDCCPPSK2XPQW', # TeraCopy
    '9PLJWWSV01LK', # Twinkle Tray
    'XP89DCGQ3K6VLD', # PowerToys
    '9N8G7TSCL18R' # NanaZip
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
    'RedHat.Podman',
    'RedHat.Podman-Desktop',
    'Google.QuickShare',
    'Starship.Starship',
    'StartIsBack.StartAllBack'
    'Valve.Steam'
  ) | ForEach-Object -Process {
    winget install --accept-source-agreements --accept-package-agreements --source winget --id "$_"
  }

  Install-Module -Scope CurrentUser -Force -AllowClobber -Name @(
    'PowerShellGet',
    'PSReadLine',
    'posh-git'
  )
}

function main {
  $ErrorActionPreference = 'SilentlyContinue'

  Install-Base

  Set-Base
  Set-Shell
  Set-Prompt
  Set-RunCom
}

main
