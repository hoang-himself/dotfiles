Set-Alias -Name 'vx' -Value 'deactivate'

function va {
  param(
    [string]$venv_path = '.venv'
  )

  $venv_path = [System.IO.Path]::GetFullPath($venv_path)
  $activate_script = Join-Path -Path $venv_path -ChildPath 'Scripts\Activate.ps1'
  $pip_exe = Join-Path -Path $venv_path -ChildPath 'Scripts\pip.exe'
  $requirements_file = 'requirements.txt'

  $python_cmd = $null
  if (Get-Command python -ErrorAction SilentlyContinue) {
    $python_cmd = 'python'
  }
  else {
    Write-Error 'Error: python command not found in PATH'
    return 1
  }

  if (Test-Path -Path $venv_path -PathType Container) {
    if (Test-Path -Path $activate_script -PathType Leaf) {
      . $activate_script
      return
    }

    Write-Error "Error: virtual environment exists but activation script not found at: $activate_script"
    return 1
  }

  & $python_cmd -m venv --upgrade-deps $venv_path

  if (-not (Test-Path -Path $activate_script -PathType Leaf)) {
    Write-Error "Error: failed to create virtual environment at: $venv_path"
    return 1
  }

  . $activate_script
  & $pip_exe install wheel

  if (Test-Path -Path $requirements_file -PathType Leaf) {
    & $pip_exe install -r $requirements_file
  }
}
