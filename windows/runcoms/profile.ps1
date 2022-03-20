Import-Module -Name posh-git
Import-Module -Name oh-my-posh
Import-Module -Name Terminal-Icons

# oh-my-posh prompt init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v$(oh-my-posh --version)/themes/jandedobbeleer.omp.json" | Invoke-Expression
oh-my-posh prompt init pwsh --config "$env:LOCALAPPDATA\oh-my-posh\themes\jandedobbeleer.omp.json" | Invoke-Expression
oh-my-posh completion powershell | Out-String | Invoke-Expression

# https://docs.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

Push-Location (Split-Path -Parent $Profile)
@('plugins', 'functions', 'aliases', 'exports', 'extra') | Where-Object { Test-Path "$_.ps1" } | ForEach-Object -Process { Invoke-Expression ". .\$_.ps1" }
Pop-Location
