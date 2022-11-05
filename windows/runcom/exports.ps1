$env:POSH_GIT_ENABLED = $true

$MaximumHistoryCount = 1024
Set-PSReadLineOption -MaximumHistoryCount $MaximumHistoryCount
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -ShowToolTips
