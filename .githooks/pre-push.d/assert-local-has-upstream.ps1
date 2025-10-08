param([string]$BranchName)

function Test-BranchHasUpstream {
  param([string]$Branch)

  try {
    $upstream = git config --get "branch.$Branch.remote" 2>$null
    return $null -ne $upstream -and $upstream -ne '' -and $upstream -ne '.'
  }
  catch {
    return $false
  }
}

function Remove-BranchUpstream {
  [CmdletBinding(SupportsShouldProcess)]
  param([string]$Branch)

  if ($PSCmdlet.ShouldProcess($Branch, "Unset upstream")) {
    Write-Output "Unsetting upstream for branch '$Branch'."

    try {
      git branch --unset-upstream $Branch 2>$null
      if ($LASTEXITCODE -eq 0) {
        Write-Output "Successfully unset upstream for branch '$Branch'"
        return $true
      }
      else {
        Write-Warning "Failed to unset upstream for branch '$Branch'"
        return $false
      }
    }
    catch {
      Write-Warning "Error unsetting upstream for branch '$Branch': $_"
      return $false
    }
  }
  else {
    Write-Output "Skipped unsetting upstream for branch '$Branch' (WhatIf or user declined)"
    return $false
  }
}

if ($BranchName -match '^local($|/)') {
  if (Test-BranchHasUpstream $BranchName) {
    Write-Output "Branch '$BranchName' starts with 'local' and has upstream set."
    Remove-BranchUpstream $BranchName | Out-Null
  }
}

exit 0
