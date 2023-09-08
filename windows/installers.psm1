function Install-Base {
  Get-PackageProvider | Where-Object -Property Name -EQ 'NuGet' | Install-PackageProvider -Force
  Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
  Update-Module -Force

  winget install --source winget --id 'GnuPG.Gpg4win' --override "/C=`"$PWD\configs\gpg4win.ini`" /S"
  @(
    'JohnTaylor.lesskey',
    'JohnTaylor.less',
    'Neovim.Neovim'
  ) | ForEach-Object -Process { winget install --source winget --id "$_" }

  Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName 'TelnetClient'

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

function Install-Virtualization {
  Enable-WindowsOptionalFeature -Online -All -NoRestart `
    -FeatureName @('HypervisorPlatform', 'VirtualMachinePlatform','Microsoft-Windows-Subsystem-Linux', 'Microsoft-Hyper-V')

  winget install --source winget --id 'RedHat.Podman-Desktop'
  winget install --source winget --id 'RedHat.Podman'
}

function Install-Pyenv {
  Invoke-WebRequest -UseBasicParsing `
    -Uri 'https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1' `
    -OutFile './install-pyenv-win.ps1'
  &'./install-pyenv-win.ps1'
  Remove-Item -Path './install-pyenv-win.ps1'
}

function Install-Nvm {
  winget install --source winget --id 'CoreyButler.NVMforWindows'
}
