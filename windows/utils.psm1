function Add-ToUserEnvironment {
  param(
    [string]$Name,
    [string]$Value
  )
  $RegistryPath = 'HKCU:\Environment'
  New-ItemProperty -Path "$RegistryPath" -Name "$Name" -Value "$Value" -PropertyType 'ExpandString' -Force
}

function Add-ToUserPath {
  param(
    [string]$Path,
    [bool]$Prepend = $false
  )
  $RegistryPath = 'HKCU:\Environment'

  $oldPath = (Get-Item -Path "$RegistryPath").GetValue(
    'Path', # the registry-value name
    $null, # the default value to return if no such value exists.
    'DoNotExpandEnvironmentNames' # the option that suppresses expansion
  )

  if ($oldPath -ilike "*$Path*") { return }

  if ($Prepend) {
    Set-ItemProperty -Path "$RegistryPath" -Name 'Path' -Value "$Path;$oldPath" -Force
  }
  else {
    Set-ItemProperty -Path "$RegistryPath" -Name 'Path' -Value "$oldPath;$Path" -Force
  }
}
