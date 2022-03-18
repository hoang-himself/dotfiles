Push-Location (Join-Path (Split-Path -Parent $Profile) "plugins")
. .\common-aliases.ps1
. .\git.ps1
Pop-Location
