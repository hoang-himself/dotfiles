function Set-Shell {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  @(
    'PowerShellGet',
    'PSReadLine',
    'posh-git'
  ) | ForEach-Object -Process { Install-Module -Name $_ -Scope CurrentUser -Force }

  $PROFILE_HOME = Split-Path -Parent $Profile

  New-Item -ItemType Directory -Path "$PROFILE_HOME" -Force
  New-Item -ItemType Directory -Path "$PROFILE_HOME\profile.d" -Force

  Get-ChildItem -Path '.\runcoms\*.ps1' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink -Path "$PROFILE_HOME\$($_.Name)" `
      -Target $_.FullName -Force
  }

  Get-ChildItem -Path '.\runcoms\profile.d\*' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink -Path "$PROFILE_HOME\profile.d\$($_.Name)" `
      -Target $_.FullName -Force
  }
}

function Set-Prompt {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType SymbolicLink -Path "$env:XDG_CONFIG_HOME\starship.toml" `
    -Target $(Resolve-Path -LiteralPath '..\common\runcoms\starship.toml') -Force
}

function Set-OpenSSH {
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
    -Target $(Resolve-Path -LiteralPath '.\configs\sshd_config') -Force

  Get-ChildItem -Path '..\common\configs\sshd_config.d' | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:ProgramData\ssh\sshd_config.d\$($_.Name)" `
      -Target $_.FullName -Force
  }

  Get-ChildItem -Path '..\common\configs\ssh_config.d' | ForEach-Object -Process {
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
    -Target $(Resolve-Path -LiteralPath '..\common\configs\git') -Force

  New-Item -ItemType SymbolicLink `
    -Path "$env:XDG_CONFIG_HOME\nvim" `
    -Target $(Resolve-Path -LiteralPath '..\common\runcoms\neovim') -Force
}

function Set-Virtualization {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  Get-ChildItem -Path '..\common\configs\containers\*.conf' `
  | ForEach-Object -Process {
    New-Item -ItemType SymbolicLink `
      -Path "$env:XDG_CONFIG_HOME\containers\$($_.Name)" `
      -Target $_.FullName -Force
  }
}
