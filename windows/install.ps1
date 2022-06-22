function Assert-Elevated {
  # Get the ID and security principal of the current user account
  $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $MyPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyIdentity)
  # Check to see if we are currently running "as Administrator"
  return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Self elevate administrative permissions in this script
if (-not (Assert-Elevated)) {
  Start-Process pwsh "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args`"" -Verb 'RunAs'
  exit
}

$env:ProfileDir = Split-Path -Parent $Profile
$env:PluginsDir = Join-Path $env:ProfileDir 'plugins'
New-Item -Path "$env:ProfileDir" -ItemType Directory -ErrorAction SilentlyContinue -Force
New-Item -Path "$env:PluginsDir" -ItemType Directory -ErrorAction SilentlyContinue -Force
New-Item -Path "$env:USERPROFILE\.config" -ItemType Directory -ErrorAction SilentlyContinue -Force

. .\bootstrap.ps1

function Set-Prompt {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  winget install --id Starship.Starship

  # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
  Get-ChildItem -Path '.\runcoms\*' -Include '*.ps1' | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$env:ProfileDir\$($_.Name)" `
      -Target $_.FullName -Force
  }
  Get-ChildItem -Path '.\runcoms\plugins\' | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$env:PluginsDir\$($_.Name)" `
      -Target $_.FullName -Force
  }
  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\starship.toml" `
    -Target $(Resolve-Path -LiteralPath '..\starship.toml') -Force
  New-Item -ItemType Directory -Path "$env:ProfileDir\profile.d" -Force
}

function Set-Pyenv {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
  param()
  pyenv update
  $python_target = '3.10.4'
  pyenv install -q "$python_target"
  pyenv global "$python_target"
  pip install --upgrade pip setuptools wheel
}

function Set-OpenSSH {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType Directory -Path "$env:ProgramData\ssh\sshd_config.d" -Force
  New-Item -ItemType Directory -Path "$env:ProgramData\ssh\keys\$env:USERNAME" -Force
  #icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
  New-Item -ItemType Directory -Path "$env:USERPROFILE\.ssh\config.d" -Force
  New-Item -ItemType Directory -Path "$env:USERPROFILE\.ssh\sockets" -Force

  New-Item -ItemType SymbolicLink -Path "$env:ProgramData\ssh\sshd_config" `
    -Target $(Resolve-Path -LiteralPath '.\configs\openssh\sshd_config') -Force
  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.ssh\config" `
    -Target $(Resolve-Path -LiteralPath '.\configs\openssh\ssh_config') -Force

  New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -PropertyType String `
    -Name DefaultShell -Value 'C:\Program Files\PowerShell\7\pwsh.exe' -Force
}

function Set-WSL {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.wslconfig" `
    -Target $(Resolve-Path -LiteralPath '.\configs\wslconfig') -Force
}

function Set-Config {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\git\config" `
    -Target $(Resolve-Path -LiteralPath '.\configs\git\config') -Force
  @(
    'attributes',
    'ignore',
    'message'
  ) | ForEach-Object {
    New-Item -ItemType SymbolicLink `
      -Path "$env:USERPROFILE\.config\git\$_" `
      -Target $(Resolve-Path -LiteralPath "..\.git$_") -Force
  }
  Get-ChildItem -Path '.\configs\git\bash' | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.$($_.Name)" `
      -Target $_.FullName -Force
  }
  #Add-Content "$env:USERPROFILE\.gitconfig.local" $null

  # Apparently, Git for Windows includes its own gpg
  # Normally, typing `gpg` in any shell will invoke Gpg4win or GnuPG
  # But Git signs with its own GPG, so usually we need to set the path
  # Remember to import your key with Git Bash or Git won't sign your commits
  Get-ChildItem -Path '.\configs\gnupg\' | ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gnupg\$($_.Name)" `
      -Target $_.FullName -Force
    New-Item -ItemType SymbolicLink -Path "$env:APPDATA\gnupg\$($_.Name)" `
      -Target $_.FullName -Force
  }

  @(
    @('', ''),
    @('Preview', '_preview')
  ) | ForEach-Object {
    New-Item -ItemType SymbolicLink `
      -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal$($_[0])_8wekyb3d8bbwe\LocalState\settings.json" `
      -Target $(Resolve-Path -LiteralPath ".\configs\wt\profile$($_[1]).json") -Force
  }
}

function main {
  #Uninstall-Bloat
  Install-Base
  Install-Prompt && Set-Prompt
  Install-Pyenv && Set-Pyenv
  Install-OpenSSH && Set-OpenSSH
  Install-WSL && Set-WSL
  Set-Config
}

$args | ForEach-Object {
  switch ($_) {
    #'-i' { main }
    #'--install' { main }
    { $_ -in @('-i', '--install') } { main }
    default { Write-Output "Unrecognized option `"$_`"" }
  }
}
