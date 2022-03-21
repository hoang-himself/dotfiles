Push-Location (Join-Path (Split-Path -Parent $Profile) "plugins")
Import-Module -Name '.\common-aliases.psm1'
Import-Module -Name '.\dotenv.psm1'
Import-Module -Name '.\git.psm1'
Pop-Location
