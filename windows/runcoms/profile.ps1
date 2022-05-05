Import-Module -Name 'posh-git'
Import-Module -Name 'Terminal-Icons'

$env:Path = "$env:LOCALAPPDATA\starship;$env:Path"
Invoke-Command -ScriptBlock $([ScriptBlock]::Create(
    $(starship init powershell)
  ))

$MaximumHistoryCount = 1024
Set-PSReadLineOption -MaximumHistoryCount 1024

Push-Location (Split-Path -Parent $Profile)
@(
  'exports',
  'plugins',
  'bindings',
  'completions',
  'functions',
  'aliases',
  'extra'
) | Where-Object {
  Test-Path "$_.ps1"
} | ForEach-Object -Process {
  . ".\$_.ps1"
}
Pop-Location
