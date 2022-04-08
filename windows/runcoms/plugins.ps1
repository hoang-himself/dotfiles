Push-Location (Join-Path (Split-Path -Parent $Profile) "plugins")
@(
  'git',
  'python'
) | ForEach-Object {
  Import-Module -Name ".\$_.psm1"
}
Pop-Location
