# Python
Set-Alias -Name 'vx' -Value 'deactivate'
function va([String] $VenvPath) {
  if (-not "$VenvPath") { $VenvPath = '.venv' }
  if (-not (Test-Path -LiteralPath "$VenvPath")) {
    python -m venv --upgrade-deps "$VenvPath"
    Add-Content requirements.txt $null
    & ".\$VenvPath\Scripts\Activate.ps1"
    pip install wheel
  }
  else {
    & ".\$VenvPath\Scripts\Activate.ps1"
  }
}
