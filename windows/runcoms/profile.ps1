Import-Module -Name 'posh-git'
Import-Module -Name 'oh-my-posh'
Import-Module -Name 'Terminal-Icons'

#Invoke-Command -ScriptBlock $([ScriptBlock]::Create(
#    $(oh-my-posh prompt init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v$(oh-my-posh --version)/themes/jandedobbeleer.omp.json")
#  ))
Invoke-Command -ScriptBlock $([ScriptBlock]::Create(
    $(oh-my-posh prompt init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json")
  ))
Invoke-Command -ScriptBlock $([ScriptBlock]::Create(
    $(oh-my-posh completion powershell)
  ))
$MaximumHistoryCount = 512
Set-PSReadLineOption -MaximumHistoryCount 1024

Push-Location (Split-Path -Parent $Profile)
@(
  'exports',
  'plugins',
  'functions',
  'bindings',
  'aliases',
  'extra'
) | Where-Object {
  Test-Path "$_.ps1"
} | ForEach-Object -Process {
  . ".\$_.ps1"
}
Pop-Location
