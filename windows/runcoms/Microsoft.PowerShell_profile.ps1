$ssh_hostname = {
  @('raspberrypi',
    'raspberrypi.local'
  ) | ForEach-Object {
    Write-Output "$_"
  }
}
Register-ArgumentCompleter -Native -CommandName 'ssh' -ScriptBlock $ssh_hostname
