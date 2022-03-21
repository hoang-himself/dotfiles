function Set-DotEnv {
  <#
  .SYNOPSIS
  Exports environment variable from the .env file to the current process.
  .DESCRIPTION
  This function looks for `.env` file in the current directory, if present
  it loads the environment variable mentioned in the file to the current process.
  .EXAMPLE
  Set-DotEnv
  .EXAMPLE
  To assign value, use "=" operator
  <variable name>=<value>
  .EXAMPLE
  To prefix value to an existing env variable, use ":=" operator
  <variable name>:=<value>
  .EXAMPLE
  To suffix value to an existing env variable, use "=:" operator
  <variable name>=:<value>
  .EXAMPLE
  To comment a line, use "#" at the start of the line
  # This is a comment, it will be skipped when parsing
  .EXAMPLE
  This is function is called by convention in PowerShell
  Auto exports the env variable at every prompt change
  function prompt {
    Set-DotEnv
  }
  .LINK
  https://github.com/rajivharris/Set-PsEnv/blob/master/Set-PsEnv.psm1
  #>
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
  param(
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true)]
    [string]
    $LocalEnvFile = '.env'
  )

  if ($Global:PreviousDir -eq (Get-Location).Path) {
    Write-Verbose 'Set-DotEnv: Skipping same dir'
    return
  }
  else {
    $Global:PreviousDir = (Get-Location).Path
  }

  # Return if no env file
  if (-not (Test-Path $LocalEnvFile)) {
    Write-Verbose "No $LocalEnvFile file"
    return
  }

  # Read the local env file
  $content = Get-Content $LocalEnvFile -ErrorAction Stop
  Write-Verbose "Parsed $LocalEnvFile file"

  # Load the content to environment
  foreach ($line in $content) {

    if ([string]::IsNullOrWhiteSpace($line)) {
      Write-Verbose 'Skipping empty line'
      continue
    }

    # Ignore comments
    if ($line.StartsWith('#')) {
      Write-Verbose "Skipping comment line $line"
      continue
    }

    # Prefix operator
    if ($line -like '*:=*') {
      Write-Verbose 'Prefix'
      $kvp = $line -split @(':=', 2)
      $key = $kvp[0].Trim()
      $value = '{0};{1}' -f $kvp[1].Trim(), [System.Environment]::GetEnvironmentVariable($key)
    }
    elseif ($line -like '*=:*') {
      Write-Verbose 'Suffix'
      $kvp = $line -split @('=:', 2)
      $key = $kvp[0].Trim()
      $value = '{1};{0}' -f $kvp[1].Trim(), [System.Environment]::GetEnvironmentVariable($key)
    }
    else {
      Write-Verbose 'Assign'
      $kvp = $line -split @('=', 2)
      $key = $kvp[0].Trim()
      $value = $kvp[1].Trim()
    }

    Write-Verbose "$key=$value"

    if ($PSCmdlet.ShouldProcess("Variable $key", "Value $value")) {
      [Environment]::SetEnvironmentVariable($key, $value, 'Process') | Out-Null
    }
  }
}
