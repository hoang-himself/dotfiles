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

Push-Location (Split-Path -Parent $Profile)
@('exports', 'plugins', 'functions', 'aliases', 'extra') | Where-Object { Test-Path "$_.ps1" } | ForEach-Object -Process { . ".\$_.ps1" }
Pop-Location
