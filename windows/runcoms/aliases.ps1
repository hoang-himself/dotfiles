# Python
Set-Alias -Name 'vx' -Value 'deactivate'
function va($venv_path) {
  $venv_path = if (! "$venv_path") { '.venv' }

  if (!(Test-Path -LiteralPath "$venv_path")) {
    python -m venv --upgrade-deps "$venv_path"
    Add-Content requirements.txt $null
    . ".\$venv_path\Scripts\Activate.ps1"
    pip install wheel
  }
  else {
    . ".\$venv_path\Scripts\Activate.ps1"
  }
}
