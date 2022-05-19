function ssh-hostgen {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
  param()
  # Urban myth
  # Throw is used to terminate an inner block of code and return to the calling block
  if ($args.Length -ne 5) {
    Write-Output 'ssh-hostgen <algorithm> <host> <hostname> <port> <user>'
    Write-Output ''
    Write-Output '    algorithm: ed25519, ecdsa, dsa, rsa'
    Write-Output '    host:      alias that you use to access this host'
    Write-Output '    hostname:  hostname of the host'
    Write-Output '    port:      port of the host, usually 22'
    Write-Output '    user:      user to login to the host'
    return
  }

  $algorithm = switch ($args[0]) {
    'ed25519' { @('ed25519', '') }
    'ecdsa' { @('ecdsa', '-b 521') }
    'dsa' { @('dsa', '') }
    'rsa' { @('rsa', '-b 4096') }
    default {
      throw [System.ArgumentException] 'algorithm must be one of ed25519, ecdsa, dsa, rsa'
    }
  }
  $h = $args[1]
  $hostname = $args[2]
  $p = if ($args[3] -is [int]) {
    $args[3]
  }
  else {
    throw [System.ArgumentException] 'port must be an integer'
  }
  $u = $args[4]

  & 'ssh-keygen' -t @algorithm -f "$HOME/.ssh/id_$($args[0])_$h" -C "$u@$hostname"

  Add-Content -Path "$HOME/.ssh/config.d/$hostname.conf" -Value @"
Host $h
  HostName $hostname
  CanonicalizeHostname yes
  Port $p
  User $u
  IdentityFile ~/.ssh/id_$($args[0])_$h.pub
  IdentitiesOnly yes

"@

  Write-Output ''
  Write-Output 'Add your new public key to the authorized_keys file of the host if possible'
  Write-Output ''
  Write-Output "Get-Content $HOME/.ssh/id_$($args[0])_$h.pub | ssh $h 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'"
}

function Update-Prompt {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  $STARSHIP_ROOT = "$env:LOCALAPPDATA\starship"
  Invoke-WebRequest -Uri 'https://github.com/starship/starship/releases/latest/download/starship-x86_64-pc-windows-msvc.zip' `
    -OutFile "$STARSHIP_ROOT\starship-x86_64-pc-windows-msvc.zip"
  Expand-Archive -Path "$STARSHIP_ROOT\starship-x86_64-pc-windows-msvc.zip" `
    -DestinationPath "$STARSHIP_ROOT" -Force
  Remove-Item -Path "$STARSHIP_ROOT\starship-x86_64-pc-windows-msvc.zip"
}

function New-TemporaryFolder {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  $TMPDIR = "$($env:TMP)\tmp$([Convert]::ToString((Get-Random 65535),16).padleft(4,'0')).tmp"
  New-Item -ItemType Directory -Path $TMPDIR
  Push-Location
  Set-Location -Path $TMPDIR
}

function Remove-TemporaryFolder {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  Pop-Location
  Remove-Item -Path $TMPDIR -Recurse -Force
}

# Common Editing needs
function Edit-Host {
  sudo "$(if ($null -ne $env:EDITOR) { $env:EDITOR } else { 'notepad' })" "$env:windir\system32\drivers\etc\hosts"
}

# Reload the $env object from the registry
function Update-Environment {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  $locations = @('HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'HKCU:\Environment')

  $locations | ForEach-Object {
    $k = Get-Item $_
    $k.GetValueNames() | ForEach-Object {
      $name = $_
      $value = $k.GetValue($_)
      Set-Item -Path Env:\$name -Value $value
    }
  }

  $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

# Set a permanent Environment variable, and reload it into $env
function Set-Environment {
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [Parameter(Mandatory = $true)]
    [String]$Variable,
    [Parameter(Mandatory = $true)]
    [String]$Value
  )
  Set-ItemProperty -Path 'HKCU:\Environment' -Name $Variable -Value $Value
  # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
  #[System.Environment]::SetEnvironmentVariable("$Variable", "$Value", "User")
  Set-Item -Path "Env:$Variable" -Value $Value
}

# Remove a permanent Environment variable
function Remove-Environment {
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [Parameter(Mandatory = $true)]
    [String]$Variable
  )
  Remove-ItemProperty -Path 'HKCU:\Environment' -Name $Variable
  # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
  #[System.Environment]::SetEnvironmentVariable("$Variable", $null, "User")
  Remove-Item -Path "Env:\${Variable}"
}

# Add a folder to $env:Path
function Add-PrependEnvPath([String]$path) {
  if ($path.Equals('.')) { $path = (Get-Location) }
  if (Test-Path -LiteralPath $path) {
    $env:Path = "$path;" + $env:Path
  }
  else {
    throw 'Invalid path'
  }
}
function Add-AppendEnvPath([String]$path) {
  if ($path.Equals('.')) { $path = (Get-Location) }
  if (Test-Path -LiteralPath $path) {
    $env:Path = "$path;" + $env:Path
  }
  else {
    throw 'Invalid path'
  }
}
