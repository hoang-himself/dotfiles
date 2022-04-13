[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

function Get-SSHHost($sshConfigPath) {
  Get-Content -Path $sshConfigPath `
  | Select-String -Pattern '^Host ' `
  | ForEach-Object { $_ -replace 'Host ', '' } `
  | ForEach-Object { $_ -split ' ' } `
  | Sort-Object -Unique `
  | Select-String -Pattern '^.*[*!?].*$' -NotMatch
}

Register-ArgumentCompleter -CommandName 'ssh', 'scp', 'sftp' -Native -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)

  $sshPath = "$env:USERPROFILE\.ssh"

  $hosts = Get-Content -Path "$sshPath\config" `
  | Select-String -Pattern '^Include '
  | ForEach-Object { $_ -replace 'Include ', '' }
  | ForEach-Object { Get-SSHHost "$sshPath/$_" } `

  $hosts += Get-SSHHost "$sshPath\config"
  $hosts = $hosts | Sort-Object -Unique

  $hosts | Where-Object { $_ -like "$wordToComplete*" } `
  | ForEach-Object { $_ }
}

# function Get-SSHKnownHost($sshKnownHostsPath) {
#   Get-Content -Path $sshKnownHostsPath `
#   | ForEach-Object { $_.split(' ')[0] } `
#   | Sort-Object -Unique
# }

# Register-ArgumentCompleter -CommandName 'ssh', 'scp', 'sftp' -Native -ScriptBlock {
#   param($wordToComplete, $commandAst, $cursorPosition)

#   $hosts = Get-SSHKnownHost "$env:USERPROFILE\.ssh\known_hosts"

#   if ($wordToComplete -match '^(?<user>[-\w/\\]+)@(?<host>[-.\w]+)$') {
#     $hosts | Where-Object { $_ -like "$($Matches['host'].ToString())*" } `
#     | ForEach-Object { "$($Matches['user'].ToString())@$_" }
#   }
# }
