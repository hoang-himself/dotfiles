Push-Location (Join-Path (Split-Path -Parent $Profile) "plugins")
@(
  'common-aliases',
  'git',
  'python'
) | ForEach-Object {
  Import-Module -Name ".\$_.psm1"
}
Pop-Location
