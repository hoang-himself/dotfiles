$env:POSH_GIT_ENABLED = $true
$env:VSCODE = 'code-insiders'

$MaximumHistoryCount = 1024
Set-PSReadLineOption -MaximumHistoryCount $MaximumHistoryCount
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -ShowToolTips

$PSDefaultParameterValues = @{}
$PSDefaultParameterValues.Add('Get-ChildItem:Exclude', '.*')
