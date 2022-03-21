Push-Location (Join-Path (Split-Path -Parent $Profile) "plugins")
Import-Module .\common-aliases.psm1
Import-Module .\git.psm1
Pop-Location
