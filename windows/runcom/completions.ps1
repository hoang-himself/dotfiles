[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

function Get-SSHHost($sshConfigPath) {
  $sshConfigPath = $sshConfigPath.Replace('/', '\')

  if ($sshConfigPath -NotMatch ':\\|^(\\|~)') {
    $sshConfigPath = '~\.ssh\' + $sshConfigPath
  }

  Get-Content -Path $sshConfigPath `
  | Select-String -Pattern '^Host ' `
  | ForEach-Object -Process { $_ -replace 'Host ', '' } `
  | ForEach-Object -Process { $_ -split '\s+' } `
  | Sort-Object -Unique `
  | Select-String -NotMatch -Pattern '[?!*]'
}

function Get-SSHKnownHost($sshKnownHostsPath) {
  Get-Content -Path $sshKnownHostsPath `
  | ForEach-Object -Process { ($_ -split '\s+')[0] } `
  | Sort-Object -Unique
}

Register-ArgumentCompleter -CommandName @('ssh', 'scp', 'sftp') -Native -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)

  $sshPath = "$env:USERPROFILE\.ssh"

  [Collections.Generic.List[String]]$config_hosts = Get-Content -Path "$sshPath\config" `
  | Select-String -Pattern '^Include ' `
  | ForEach-Object -Process { $_ -replace 'Include ', '' } `
  | ForEach-Object -Process { Get-SSHHost "$_" }
  $config_hosts += Get-SSHHost "$sshPath\config"

  $config_hosts = $config_hosts | Sort-Object -Unique

  $config_hosts | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object -Process { $_ }
}

<#
Register-ArgumentCompleter -CommandName @('ssh', 'scp', 'sftp') -Native -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)

  $sshPath = "$env:USERPROFILE\.ssh"

  [Collections.Generic.List[String]]$config_hosts = Get-Content -Path "$sshPath\config" `
  | Select-String -Pattern '^Include ' `
  | ForEach-Object -Process { $_ -replace 'Include ', '' } `
  | ForEach-Object -Process { Get-SSHHost "$_" }
  $config_hosts += Get-SSHHost "$sshPath\config"

  $config_hosts = $config_hosts | Sort-Object -Unique
  $known_hosts = Get-SSHKnownHost "$sshPath\known_hosts" | Sort-Object -Unique

  if ($wordToComplete -match '^(?<user>[-\w/\\]+)@(?<host>[-.\w]+)$') {
    $known_hosts | Where-Object { $_ -like "$($Matches['host'].ToString())*" } `
    | ForEach-Object -Process { "$($Matches['user'].ToString())@$_" }
  } else {
    $config_hosts | Where-Object { $_ -like "$wordToComplete*" } `
    | ForEach-Object -Process { $_ }
  }
}
#>
