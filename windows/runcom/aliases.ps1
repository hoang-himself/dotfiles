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
  $params = @{
    'FilePath'         = 'pwsh'
    'Verb'             = 'RunAs'
    'WorkingDirectory' = $(Get-Location)
  }

  if ($args.Count -le 0) {
    Start-Process @params
    return
  }

  switch ((Get-Command $args[0]).CommandType) {
    'Application' {
      $params['FilePath'] = $args[0]
      if ($args.Count -gt 1) {
        $params['ArgumentList'] = $args[1..($args.Count - 1)]
      }
    }
    'ExternalScript' {
      $params['ArgumentList'] = @('-File', $args[0])
      if ($args.Count -gt 1) {
        $params['ArgumentList'] += $args[1..($args.Count - 1)]
      }
    }
    { $_ -in @('Alias', 'Cmdlet', 'Function') } {
      $params['ArgumentList'] = "-NoExit -Command & { $args }"
    }
    default {
      $exception = New-Object System.ArgumentException("Invalid command type: $_")
      throw $exception
    }
  }

  Start-Process @params
}

function which($name) {
  $ErrorActionPreference = 'SilentlyContinue'
  Get-Command -Name $name | Select-Object -ExpandProperty Definition
}

function touch($file) { '' | Out-File -FilePath $file -Encoding ASCII }

function mkcd($path) { New-Item -ItemType Directory -Path $path && Set-Location -Path $path }

function mktmp {
  $TMPDIR = "$($env:TMP)\tmp$([Convert]::ToString((Get-Random 65535),16).padleft(4,'0')).tmp"
  New-Item -ItemType Directory -Path $TMPDIR
  Push-Location -Path $TMPDIR
}

function rmtmp {
  $TMPDIR = Get-Location
  Pop-Location
  Remove-Item -Path $TMPDIR -Recurse -Force
}

function Clear-GlobalHistory {
  Clear-History
  Set-Content -Path $($(Get-PSReadLineOption).'HistorySavePath') -Value ''
  Set-Content -Path "$env:USERPROFILE\.bash_history" -Value ''
}
