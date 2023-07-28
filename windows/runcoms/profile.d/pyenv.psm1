Set-Alias -Name 'vx' -Value 'deactivate'

function va {
  $venvPath = if ($args) { $args } else { '.venv' }

  if ((Get-Item -Path "$venvPath" -ErrorAction SilentlyContinue).PSIsContainer) {
    &".\$venvPath\Scripts\Activate.ps1"
    return
  }

  python -m venv --upgrade-deps "$venvPath"
  &".\$venvPath\Scripts\Activate.ps1"
  # --upgrade-deps already includes pip and setuptools
  &".\$venvPath\Scripts\pip.exe" install wheel

  $requirementsFile = 'requirements.txt'
  if (Test-Path -Path "$requirementsFile" -PathType Leaf) {
    &".\$venvPath\Scripts\pip.exe" install -r "$requirementsFile"
  } else {
    Add-Content -Path "$requirementsFile" -Value $null
  }
}
