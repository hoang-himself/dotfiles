function Assert-Elevated {
  # Get the ID and security principal of the current user account
  $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $MyPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyIdentity)
  # Check to see if we are currently running "as Administrator"
  return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Update-Upgrade {
  Update-Help -Force
  Update-Module -Force
}

function Install-OMP {
  @(
    'oh-my-posh',
    'posh-git'
  ) | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser -Force
  }
}

function Install-OpenSSH {
  # https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
  Add-WindowsCapability -Online -Name OpenSSH.Client
  Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service

  Add-WindowsCapability -Online -Name OpenSSH.Server
  Get-Service sshd | Set-Service -StartupType Automatic -PassThru | Start-Service

  # Confirm the Firewall rule is configured. It should be created automatically by setup
  if (!(Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
  }
}

function Install-WSL {
  # Get-WindowsOptionalFeature -Online
  Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName `
  @('VirtualMachinePlatform', 'Microsoft-Windows-Subsystem-Linux') | Out-Null
}

function Install-dotNet {
  pwsh -NoProfile -ExecutionPolicy Unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1'))) -Channel Current"
}

function Set-ComputerName {
  $ComputerName = Read-Host -Prompt 'Enter New Computer Name'
  Rename-Computer -NewName $ComputerName
}

function shift {
  # Prevent user from running this script
  exit 1

  $args = $args | Select-Object -Skip 1
}

function Get-EnvVariable {
  # Prevent user from running this script
  exit 1

  # Env, aliases, functions and more are stored in virtual drives
  # Use this command to get them
  Get-PSDrive

  # Get all environment variables
  # or use `dir` because `dir` is an alias
  Get-ChildItem -Path Env:
}
