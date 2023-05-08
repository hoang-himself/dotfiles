# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location -Path "$HOME" }
# Pwsh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location -Path '..' }; Set-Alias -Name '..' -Value 'Set-ParentLocation'
${function:...} = { Set-Location -Path '..\..' }
${function:....} = { Set-Location -Path '..\..\..' }
${function:.....} = { Set-Location -Path '..\..\..\..' }
${function:......} = { Set-Location -Path '..\..\..\..\..' }

Set-Alias -Name 'time' -Value 'Measure-Command'

function sudo() {
  $Params = @{
    'FilePath'         = 'pwsh'
    'Verb'             = 'RunAs'
    'WorkingDirectory' = Get-Location
  }
  if ($args.count -gt 0) {
    $Params['FilePath'] = $args[0]
  }
  if ($args.count -gt 1) {
    $Params['ArgumentList'] = $args[1..($args.count - 1)]
  }
  Start-Process @Params
}

function which($name) {
  Get-Command -Name $name -ErrorAction SilentlyContinue `
  | Select-Object -ExpandProperty Definition -ErrorAction SilentlyContinue
}

function touch($file) { '' | Out-File -FilePath $file -Encoding ASCII }

function mkcd($path) { New-Item -ItemType Directory -Path $path && Set-Location -Path $path }

function Set-Formatting {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  $editorconfig = @'
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.{bat,cmd}]
end_of_line = crlf

[*.md]
trim_trailing_whitespace = false

'@

  if (Test-Path -Path '.editorconfig') {
    Write-Output -InputObject $editorconfig
  }
  else {
    Set-Content -Path '.editorconfig' -Value $editorconfig
  }
}

function New-TemporaryFolder {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  $TMPDIR = "$($env:TMP)\tmp$([Convert]::ToString((Get-Random 65535),16).padleft(4,'0')).tmp"
  New-Item -ItemType Directory -Path $TMPDIR
  Push-Location -Path $TMPDIR
}

function Remove-TemporaryFolder {
  [CmdletBinding(SupportsShouldProcess)]
  param()
  $TMPDIR = Get-Location
  Pop-Location
  Remove-Item -Path $TMPDIR -Recurse -Force
}

function Clear-GlobalHistory {
  Clear-History
  Set-Content -Path $($(Get-PSReadLineOption).'HistorySavePath') -Value ''
  Set-Content -Path "$env:USERPROFILE\.bash_history" -Value ''
}
