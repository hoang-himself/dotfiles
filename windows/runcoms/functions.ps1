# Common Editing needs
function Edit-Hosts {
  sudo "$(if ($null -ne $env:EDITOR) { $env:EDITOR } else { 'notepad' })" "$env:windir\system32\drivers\etc\hosts"
}

# Reload the $env object from the registry
function Update-Environment {
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
function Set-Environment([String] $variable, [String] $value) {
  Set-ItemProperty -Path 'HKCU:\Environment' -Name $variable -Value $value
  # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
  #[System.Environment]::SetEnvironmentVariable("$variable", "$value", "User")
  Invoke-Expression -Command "`$env:${variable} = `"$value`""
}

# Remove a permanent Environment variable
function Remove-Environment([String] $variable) {
  Remove-ItemProperty -Path 'HKCU:\Environment' -Name $variable
  # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
  #[System.Environment]::SetEnvironmentVariable("$variable", $null, "User")
  Remove-Item -Path "Env:\${variable}"
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

# Upgrade several stuffs
function update_upgrade {
  Update-Module
  Update-Help

  Push-Location
  Set-Location -Path "$env:USERPROFILE\.pyenv"
  git pull --all --prune --rebase --autostash
  Pop-Location
}
