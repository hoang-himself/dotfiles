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
    'Microsoft.PowerShell',
    'Git.Git',
    'Neovim.Neovim',
    'jftuga.less',
    'Google.QuickShare',
    'RedHat.Podman-Desktop',
    'RedHat.Podman',
    'DevToys-app.DevToys',
    'Microsoft.PowerToys'
  ) | ForEach-Object -Process { winget install --source winget --id "$_" }
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

function Install-Pyenv {
  Invoke-WebRequest -UseBasicParsing `
    -Uri 'https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1' `
    -OutFile './install-pyenv-win.ps1'
  &'./install-pyenv-win.ps1'
  Remove-Item -Path './install-pyenv-win.ps1'
}

function main {
  $ErrorActionPreference = 'SilentlyContinue'

  Install-Base
  Install-Shell
  Install-Prompt
  Install-Pyenv

  Set-Base
  Set-Shell
  Set-Prompt
  Set-RunCom
}

main
