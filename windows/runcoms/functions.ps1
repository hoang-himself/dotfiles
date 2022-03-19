# Common Editing needs
function Edit-Hosts { Invoke-Expression "sudo $(if ($null -ne $env:EDITOR) {$env:EDITOR} else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" }

# Reload the $env object from the registry
function Update-Environment {
  $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
  'HKCU:\Environment'

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
  Set-ItemProperty 'HKCU:\Environment' $variable $value
  # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
  #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
  Invoke-Expression "`$env:${variable} = `"$value`""
}

# Add a folder to $env:Path
function Add-PrependEnvPath([String]$path) { $env:PATH = $env:PATH + ";$path" }
function Add-PrependEnvPathIfExists([String]$path) { if (Test-Path $path) { Add-PrependEnvPath $path } }
function Add-AppendEnvPath([String]$path) { $env:PATH = $env:PATH + ";$path" }
function Add-AppendEnvPathIfExists([String]$path) { if (Test-Path $path) { Add-AppendEnvPath $path } }
