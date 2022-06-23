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
  ) | ForEach-Object { Get-AppxPackage -Name $_ | Remove-AppxPackage }
}

function Install-Base {
  Update-Module -Force
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
  Get-PackageProvider | Where-Object -Property Name -EQ 'NuGet' | Install-PackageProvider -Force
  @(
    'PowerShellGet',
    'PSReadLine',
    'PSScriptAnalyzer'
  ) | ForEach-Object { Install-Module -Name $_ -Scope CurrentUser -Force }
  Update-Help -Force
}

function Install-Prompt {
  # TODO make this function install Pwsh in case system is using old powershell
  @(
    'posh-git',
    'Terminal-Icons'
  ) | ForEach-Object { Install-Module -Name $_ -Scope CurrentUser -Force }

  winget install --id Starship.Starship
}

function Install-Pyenv {
  git clone --depth=1 'https://github.com/pyenv-win/pyenv-win.git' "$env:USERPROFILE\.pyenv"

  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'
  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV_ROOT' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'
  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'PYENV_HOME' `
    -Value '%USERPROFILE%\.pyenv\pyenv-win'

  $raw_hkcu_path = (Get-Item -Path 'HKCU:\Environment').GetValue(
    'Path', # the registry-value name
    $null, # the default value to return if no such value exists.
    'DoNotExpandEnvironmentNames' # the option that suppresses expansion
  )
  Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' `
    -Value $('%USERPROFILE%\.pyenv\pyenv-win\bin;%USERPROFILE%\.pyenv\pyenv-win\shims;' `
      + "$raw_hkcu_path")

  $env:PYENV_ROOT = "$HOME\.pyenv"
  $env:Path = "$env:PYENV_ROOT\bin;$env:Path"
  pyenv update
}

function Install-Python {
  $python_target = '3.10.4'
  pyenv install -q "$python_target"
  pyenv global "$python_target"
  pip install --upgrade pip setuptools wheel
}

function Install-OpenSSH {
  # https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
  Add-WindowsCapability -Online -Name OpenSSH.Client
  Get-Service -Name 'ssh-agent' | Set-Service -StartupType Automatic -PassThru | Start-Service

  Add-WindowsCapability -Online -Name OpenSSH.Server
  Get-Service -Name 'sshd' | Set-Service -StartupType Automatic -PassThru | Start-Service

  # Remove default rule as we use a different port
  Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue | Remove-NetFirewallRule
  New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' `
    -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 2255
}

function Install-WSL {
  # Get-WindowsOptionalFeature -Online
  Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName `
  @('VirtualMachinePlatform', 'Microsoft-Windows-Subsystem-Linux') | Out-Null
}
