# https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse

function Install-Client {
  Add-WindowsCapability -Online -Name OpenSSH.Client
  Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service
}

function Install-Server {
  Add-WindowsCapability -Online -Name OpenSSH.Server
  Get-Service sshd | Set-Service -StartupType Automatic -PassThru | Start-Service

}

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
  New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}
