$env:EDITOR = 'C:\Program Files\Notepad++\notepad++.exe'
$env:POSH_GIT_ENABLED = $true

Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History -PredictionViewStyle InlineView

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables
#$ErrorActionPreference = 'SilentlyContinue'
