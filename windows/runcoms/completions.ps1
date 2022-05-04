[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

function Get-SSHHost($sshConfigPath) {
  Get-Content -Path $sshConfigPath `
  | Select-String -Pattern '^Host ' `
  | ForEach-Object { $_ -replace 'Host ', '' } `
  | ForEach-Object { $_ -split ' ' } `
  | Sort-Object -Unique `
  | Select-String -Pattern '[?*]' -NotMatch
}

Register-ArgumentCompleter -CommandName 'ssh', 'scp', 'sftp' -Native -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)

  $sshPath = "$env:USERPROFILE\.ssh"

  $hosts = Get-Content -Path "$sshPath\config" `
  | Select-String -Pattern '^Include ' `
  | ForEach-Object { $_ -replace 'Include ', '' } `
  | ForEach-Object { Get-SSHHost "$sshPath\$_" }
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

#   $sshPath = "$env:USERPROFILE\.ssh"

#   $config_hosts = Get-Content -Path "$sshPath\config" `
#   | Select-String -Pattern '^Include ' `
#   | ForEach-Object { $_ -replace 'Include ', '' } `
#   | ForEach-Object { Get-SSHHost "$sshPath\$_" }
#   $config_hosts += Get-SSHHost "$sshPath\config"
#   $known_hosts = Get-SSHKnownHost "$sshPath\known_hosts"

#   $config_hosts = $config_hosts | Sort-Object -Unique
#   $known_hosts = $known_hosts | Sort-Object -Unique

#   if ($wordToComplete -match '^(?<user>[-\w/\\]+)@(?<host>[-.\w]+)$') {
#     $known_hosts | Where-Object { $_ -like "$($Matches['host'].ToString())*" } `
#     | ForEach-Object { "$($Matches['user'].ToString())@$_" }
#   }
#   else {
#     $config_hosts | Where-Object { $_ -like "$wordToComplete*" } `
#     | ForEach-Object { $_ }
#   }
# }
