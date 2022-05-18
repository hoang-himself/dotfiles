# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location -Path "$HOME" }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location -Path '..' }; Set-Alias -Name '..' -Value Set-ParentLocation
${function:...} = { Set-Location -Path '..\..' }
${function:....} = { Set-Location -Path '..\..\..' }
${function:.....} = { Set-Location -Path '..\..\..\..' }
${function:......} = { Set-Location -Path '..\..\..\..\..' }

function sudo() {
  if ($args.Length -eq 0) {
    Start-Process 'pwsh' -Verb 'RunAs'
  }
  elseif ($args.Length -eq 1) {
    Start-Process $args[0] -Verb 'RunAs'
  }
  else {
    Start-Process $args[0] -ArgumentList $args[1..$args.Length] -Verb 'RunAs'
  }
}

function which($name) {
  Get-Command -Name $name -ErrorAction SilentlyContinue `
  | Select-Object -ExpandProperty Definition -ErrorAction SilentlyContinue
}
function touch($file) { '' | Out-File -FilePath $file -Encoding ASCII }
function mkcd($path) { New-Item -ItemType Directory -Path $path && Set-Location -Path $path }
function nano() { & "$(if ($null -ne $env:EDITOR) { $env:EDITOR } else { 'notepad' })" $args }

# Navigation Shortcuts
# https://docs.microsoft.com/en-us/dotnet/api/system.environment.specialfolder
${function:dt} = { Set-Location -Path $([Environment]::GetFolderPath('Desktop')) }
${function:docs} = { Set-Location -Path $([Environment]::GetFolderPath('MyDocuments')) }
${function:dl} = { Set-Location -Path $(
    Get-ItemPropertyValue `
      -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' `
      -Name '{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}'
  )
}

Set-Alias -Name 'time' -Value 'Measure-Command'
