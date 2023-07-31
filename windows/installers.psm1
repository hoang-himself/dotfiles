function Install-Base {
  Get-PackageProvider | Where-Object -Property Name -EQ 'NuGet' | Install-PackageProvider -Force
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
  Update-Module -Force

  Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName 'HypervisorPlatform'

  winget install --source winget --id 'GnuPG.Gpg4win' --override "/C=`"$PWD\configs\gpg4win.ini`" /S"
  @(
    'JohnTaylor.lesskey',
    'JohnTaylor.less',
    'Neovim.Neovim'
  ) | ForEach-Object -Process { winget install --source winget --id "$_" }

  Add-WindowsCapability -Online -Name OpenSSH.Client
  Get-Service -Name 'ssh-agent' | Set-Service -StartupType Automatic -PassThru | Start-Service

  #Add-WindowsCapability -Online -Name OpenSSH.Server
  #Get-Service -Name 'sshd' | Set-Service -StartupType Automatic -PassThru | Start-Service

  #Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' `
  #| Remove-NetFirewallRule
  #New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' `
  #  -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}

function Install-Shell {
  winget install --source winget --id 'Microsoft.PowerShell'
}

function Install-Prompt {
  winget install --source winget --id 'Starship.Starship'
}

function Install-Containers {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
  param()
  winget install --source winget --id 'RedHat.Podman-Desktop'
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

function Install-Nvm {
  winget install --source winget --id 'CoreyButler.NVMforWindows'
}
