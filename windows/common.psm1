function Assert-Elevated {
  # Get the ID and security principal of the current user account
  $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $MyPrincipal = New-Object System.Security.Principal.WindowsPrincipal($MyIdentity)
  # Check to see if we are currently running "as Administrator"
  return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-dotNet {
  pwsh -NoProfile -ExecutionPolicy Unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1'))) -Channel Current"
}

function Set-ComputerName {
  $ComputerName = Read-Host -Prompt 'Enter New Computer Name'
  Rename-Computer -NewName $ComputerName
}

<#
# View all keybindings
Get-PSReadLineKeyHandler
 #>

<#
# Shift args
$args = $args | Select-Object -Skip 1
# or pass this instead
$args[1..$args.Length]
 #>

<#
# Get system variables
# PowerShell stores a lot of system variables in virtual drives
Get-PSDrive
# Get environment variables
Get-ChildItem -Path Env:
 #>
