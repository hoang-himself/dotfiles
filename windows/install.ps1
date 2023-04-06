#Requires -PSEdition Core -RunAsAdministrator

function Add-ToUserEnvironment {
  param(
    [string]$Name,
    [string]$Value
  )
  $RegistryPath = 'HKCU:\Environment'
  New-ItemProperty -Path "$RegistryPath" -Name "$Name" -Value "$Value" -PropertyType 'ExpandString' -Force
}

function Add-ToUserPath {
  param(
    [string]$Path,
    [bool]$Prepend = $false
  )
  $RegistryPath = 'HKCU:\Environment'

  $oldPath = (Get-Item -Path "$RegistryPath").GetValue(
    'Path', # the registry-value name
    $null, # the default value to return if no such value exists.
    'DoNotExpandEnvironmentNames' # the option that suppresses expansion
  )

  if ($oldPath -ilike "*$Path*") { return }

  if ($Prepend) {
    Set-ItemProperty -Path "$RegistryPath" -Name 'Path' -Value "$Path;$oldPath" -Force
  }
  else {
    Set-ItemProperty -Path "$RegistryPath" -Name 'Path' -Value "$oldPath;$Path" -Force
  }
}

$ErrorActionPreference = 'SilentlyContinue'

@(
  'config',
  'cache',
  'local'
) | ForEach-Object -Process {
  New-Item -Path "$env:USERPROFILE\.$_" -ItemType Directory -Force
}
@(
  'share',
  'state',
  'bin'
) | ForEach-Object -Process {
  New-Item -Path "$env:USERPROFILE\.local\$_" -ItemType Directory -Force
}

# TODO test then set
$env:XDG_CONFIG_HOME = "$env:USERPROFILE\.config"
$env:XDG_CACHE_HOME = "$env:USERPROFILE\.cache"
$env:XDG_DATA_HOME = "$env:USERPROFILE\.local\share"
$env:XDG_STATE_HOME = "$env:USERPROFILE\.local\state"
$env:XDG_BIN_HOME = "$env:USERPROFILE\.local\bin"

@(
  @('XDG_CONFIG_HOME', '%USERPROFILE%\.config'),
  @('XDG_CACHE_HOME', '%USERPROFILE%\.cache'),
  @('XDG_DATA_HOME', '%USERPROFILE%\.local\share'),
  @('XDG_STATE_HOME', '%USERPROFILE%\.local\state'),
  @('XDG_BIN_HOME', '%USERPROFILE%\.local\bin')
) | ForEach-Object -Process {
  Add-ToUserEnvironment -Name $_[0] -Value $_[1]
}

function Install-Base {
  #Add-AppxPackage -Path 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
  #Add-ToUserPath -Path '%LOCALAPPDATA%\Microsoft\WindowsApps'
  Get-PackageProvider | Where-Object -Property Name -EQ 'NuGet' | Install-PackageProvider -Force
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
  Update-Module -Force

  @(
    'PowerShellGet',
    'PSReadLine'
  ) | ForEach-Object -Process { Install-Module -Name $_ -Scope CurrentUser -Force }

  winget install --source winget --id 'GnuPG.Gpg4win' --override "/C=`"$PWD\configs\gpg4win.ini`" /S"
  @(
    'JohnTaylor.lesskey',
    'JohnTaylor.less',
    'Neovim.Neovim',
    'RedHat.Podman-Desktop'
  ) | ForEach-Object -Process { winget install --source winget --id "$_" }
}

function Install-Prompt {
  @(
    'posh-git'
  ) | ForEach-Object -Process { Install-Module -Name $_ -Scope CurrentUser -Force }

  @(
    'Microsoft.PowerShell',
    'Starship.Starship'
  ) | ForEach-Object -Process { winget install --source winget --id "$_" }
}

function Set-RunCom {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  @(
    @('EDITOR', 'nvim'),
    @('VISUAL', 'nvim'),
    @('PAGER', 'less')
  ) | ForEach-Object -Process {
    Add-ToUserEnvironment -Name $_[0] -Value $_[1]
  }

  Add-ToUserPath -Path '%XDG_BIN_HOME%' -Prepend

  $PROFILE_HOME = Split-Path -Parent $Profile

  New-Item -ItemType Directory -Path "$PROFILE_HOME" -Force
  New-Item -ItemType Directory -Path "$PROFILE_HOME\profile.d" -Force

  # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
  @(
    @('', ''),
    @('Preview', '_preview')
  ) | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal$($_[0])_8wekyb3d8bbwe\LocalState\settings.json" `
      -Target $(Resolve-Path -LiteralPath ".\configs\wt\settings$($_[1]).json") -Force
  }

  New-Item -ItemType SymbolicLink -Path "$env:XDG_CONFIG_HOME\starship.toml" `
    -Target $(Resolve-Path -LiteralPath '..\shared\runcoms\starship.toml') -Force

  Get-ChildItem -Path '.\runcoms\*.ps1' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink -Path "$PROFILE_HOME\$($_.Name)" `
      -Target $_.FullName -Force
  }
  Get-ChildItem -Path '.\runcoms\profile.d\*' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink -Path "$PROFILE_HOME\profile.d\$($_.Name)" `
      -Target $_.FullName -Force
  }
}

function Install-Pyenv {
  git clone --depth 1 'https://github.com/pyenv-win/pyenv-win.git' "$env:USERPROFILE\.pyenv"

  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'
  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV_ROOT' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'
  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV_HOME' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'

  Add-ToUserPath -Path '%USERPROFILE%\.pyenv\pyenv-win\bin'
  Add-ToUserPath -Path '%USERPROFILE%\.pyenv\pyenv-win\shims'
}

function Install-NVM {
  winget install --source winget --id 'CoreyButler.NVMforWindows'
}

function Set-NVM {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
  param()
  $NVM_HOME = "$env:APPDATA\nvm"
  Start-Process -FilePath "$NVM_HOME\nvm.exe" `
    -ArgumentList @('install', 'latest') -Wait
  Start-Process -FilePath "$NVM_HOME\nvm.exe" `
    -ArgumentList @('use', 'latest') -Wait
  Start-Process -FilePath "$NVM_HOME\nvm.exe" `
    -ArgumentList 'on' -Wait
}

function Install-OpenSSH {
  Add-WindowsCapability -Online -Name OpenSSH.Client
  Get-Service -Name 'ssh-agent' | Set-Service -StartupType Automatic -PassThru | Start-Service

  #Add-WindowsCapability -Online -Name OpenSSH.Server
  #Get-Service -Name 'sshd' | Set-Service -StartupType Automatic -PassThru | Start-Service

  #Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' `
  #| Remove-NetFirewallRule
  #New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' `
  #  -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}

function Set-OpenSSH {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType Directory -Path "$env:ProgramData\ssh\sshd_config.d" -Force
  New-Item -ItemType Directory -Path "$env:ProgramData\ssh\keys\$env:USERNAME" -Force

  @(
    'config.d',
    'id.d'
  ) | ForEach-Object -Process {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.ssh\$_" -Force
  }

  New-Item -ItemType SymbolicLink `
    -Path "$env:ProgramData\ssh\sshd_config" `
    -Target $(Resolve-Path -LiteralPath '.\configs\sshd_config') -Force

  Get-ChildItem -Path '..\shared\configs\sshd_config.d' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:ProgramData\ssh\sshd_config.d\$($_.Name)" `
      -Target $_.FullName -Force
  }
  Get-ChildItem -Path '..\shared\configs\ssh_config.d' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:ProgramData\ssh\ssh_config.d\$($_.Name)" `
      -Target $_.FullName -Force
  }

  New-Item -ItemType SymbolicLink `
    -Path "$env:USERPROFILE\.ssh\config" `
    -Target $(Resolve-Path -LiteralPath '.\configs\ssh_config') -Force

  New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -PropertyType String `
    -Name 'DefaultShell' -Value 'C:\Program Files\PowerShell\7\pwsh.exe' -Force
}

function Install-WSL {
  # Get-WindowsOptionalFeature -Online
  Enable-WindowsOptionalFeature -Online -All -NoRestart `
    -FeatureName @('VirtualMachinePlatform', 'HypervisorPlatform', 'Microsoft-Windows-Subsystem-Linux') `
  | Out-Null
}

function Set-WSL {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.wslconfig" `
    -Target $(Resolve-Path -LiteralPath '.\configs\wslconfig') -Force
}

function Set-Git {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType SymbolicLink `
    -Path "$env:XDG_CONFIG_HOME\git" `
    -Target $(Resolve-Path -LiteralPath '..\shared\configs\git') -Force

  Get-ChildItem -Path '.\configs\git\bash' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:USERPROFILE\.$($_.Name)" `
      -Target $_.FullName -Force
  }
}

function Set-Neovim {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType SymbolicLink `
    -Path "$env:XDG_CONFIG_HOME\nvim" `
    -Target $(Resolve-Path -LiteralPath '..\shared\runcoms\neovim') -Force
}

function Set-Containers {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
  [CmdletBinding(SupportsShouldProcess)]
  param()
  #Get-ChildItem -Path '..\shared\configs\containers\*.conf' `
  #| ForEach-Object -Process {
  #  New-Item -ItemType SymbolicLink `
  #    -Path "$env:XDG_CONFIG_HOME\containers\$($_.Name)" `
  #    -Target $_.FullName -Force
  #}
  New-Item -Type SymbolicLink `
    -Path "$env:XDG_CONFIG_HOME\containers\containers.conf" `
    -Target $(Resolve-Path -LiteralPath '..\shared\configs\containers\containers.conf') -Force
  #New-Item -Type SymbolicLink `
  #  -Path "$env:XDG_CONFIG_HOME\containers\registries.conf" `
  #  -Target $(Resolve-Path -LiteralPath '..\shared\configs\containers\registries.conf') -Force
  #New-Item -Type SymbolicLink `
  #  -Path "$env:XDG_CONFIG_HOME\containers\storage.conf" `
  #  -Target $(Resolve-Path -LiteralPath '..\shared\configs\containers\storage.conf') -Force
}

function main {
  Install-Base
  Install-OpenSSH
  Install-Prompt
  Install-Pyenv
  Install-WSL

  Set-RunCom
  Set-OpenSSH
  #Set-WSL
  Set-Git
  Set-Neovim
}

$args | ForEach-Object -Process {
  switch ($_) {
    #'-i' { main }
    #'--install' { main }
    { $_ -in @('-i', '--install') } { main }
    default { Write-Output -InputObject "Unrecognized option `"$_`"" }
  }
}
