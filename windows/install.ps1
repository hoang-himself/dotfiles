#Requires -PSEdition Core -RunAsAdministrator

Import-Module -Name './utils.psm1'
Import-Module -Name './installers.psm1'
Import-Module -Name './setters.psm1'

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

@(
  @('XDG_CONFIG_HOME', '%USERPROFILE%\.config'),
  @('XDG_CACHE_HOME', '%USERPROFILE%\.cache'),
  @('XDG_DATA_HOME', '%USERPROFILE%\.local\share'),
  @('XDG_STATE_HOME', '%USERPROFILE%\.local\state'),
  @('XDG_BIN_HOME', '%USERPROFILE%\.local\bin')
) | ForEach-Object -Process {
  Add-ToUserEnvironment -Name $_[0] -Value $_[1]
}

$env:XDG_CONFIG_HOME = "$env:USERPROFILE\.config"
$env:XDG_CACHE_HOME = "$env:USERPROFILE\.cache"
$env:XDG_DATA_HOME = "$env:USERPROFILE\.local\share"
$env:XDG_STATE_HOME = "$env:USERPROFILE\.local\state"
$env:XDG_BIN_HOME = "$env:USERPROFILE\.local\bin"

function main {
  $ErrorActionPreference = 'SilentlyContinue'

  Install-Base
  Install-Shell
  Install-Prompt

  Install-Virtualization
  Install-Pyenv

  Set-Shell
  Set-Prompt
  Set-OpenSSH
  Set-RunCom
}

main
