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
    [switch]$Prepend = $false
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
  } else {
    Set-ItemProperty -Path "$RegistryPath" -Name 'Path' -Value "$oldPath;$Path" -Force
  }
}

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

function Set-Base {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType Directory -Path "$env:ProgramData\ssh\sshd_config.d" -Force

  @(
    'config.d',
    'id.d'
  ) | ForEach-Object -Process {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.ssh\$_" -Force
  }

  New-Item -ItemType SymbolicLink `
    -Path "$env:ProgramData\ssh\sshd_config" `
    -Target $(Resolve-Path -LiteralPath '.\config\sshd_config') -Force

  Get-ChildItem -Path '..\common\config\sshd_config.d' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:ProgramData\ssh\sshd_config.d\$($_.Name)" `
      -Target $_.FullName -Force
  }

  Get-ChildItem -Path '..\common\config\ssh_config.d' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:ProgramData\ssh\ssh_config.d\$($_.Name)" `
      -Target $_.FullName -Force
  }

  New-Item -ItemType SymbolicLink `
    -Path "$env:USERPROFILE\.ssh\config" `
    -Target $(Resolve-Path -LiteralPath '.\config\ssh_config') -Force

  New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -PropertyType String `
    -Name 'DefaultShell' -Value 'C:\Program Files\PowerShell\7\pwsh.exe' -Force

  Get-ChildItem -Path '..\common\config\containers\*.conf' `
  | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:XDG_CONFIG_HOME\containers\$($_.Name)" `
      -Target $_.FullName -Force
  }
}

function Set-Shell {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  $PROFILE_HOME = Split-Path -Parent $Profile

  New-Item -ItemType Directory -Path "$PROFILE_HOME" -Force
  New-Item -ItemType Directory -Path "$PROFILE_HOME\profile.d" -Force

  Get-ChildItem -Path '.\runcom\*.ps1' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink -Path "$PROFILE_HOME\$($_.Name)" `
      -Target $_.FullName -Force
  }
}

function Set-Prompt {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType SymbolicLink -Path "$env:XDG_CONFIG_HOME\starship.toml" `
    -Target $(Resolve-Path -LiteralPath '..\common\runcom\starship.toml') -Force
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

  New-Item -ItemType SymbolicLink `
    -Path "$env:XDG_CONFIG_HOME\git" `
    -Target $(Resolve-Path -LiteralPath '..\common\config\git') -Force

  New-Item -ItemType SymbolicLink `
    -Path "$env:XDG_CONFIG_HOME\nvim" `
    -Target $(Resolve-Path -LiteralPath '..\common\runcom\nvim') -Force
}
