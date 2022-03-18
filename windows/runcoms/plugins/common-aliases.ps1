
# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location -Path "$HOME" }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location -Path '..' }; Set-Alias -Name '..' -Value Set-ParentLocation
${function:...} = { Set-Location -Path '..\..' }
${function:....} = { Set-Location -Path '..\..\..' }
${function:.....} = { Set-Location -Path '..\..\..\..' }
${function:......} = { Set-Location -Path '..\..\..\..\..' }

# Sudo
function sudo() {
  if ($args.Length -eq 1) {
    Start-Process $args[0] -Verb 'RunAs'
  }
  if ($args.Length -gt 1) {
    Start-Process $args[0] -ArgumentList $args[1..$args.Length] -Verb 'RunAs'
  }
}

# Basic commands
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { '' | Out-File $file -Encoding ASCII }

# Navigation Shortcuts
${function:dt} = { Set-Location -Path "$HOME\Desktop" }
${function:docs} = { Set-Location -Path "$HOME\Documents" }
${function:dl} = { Set-Location -Path "$HOME\Downloads" }

# Missing Bash aliases
Set-Alias -Name 'time' -Value 'Measure-Command'
