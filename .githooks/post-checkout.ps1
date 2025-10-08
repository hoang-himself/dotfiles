[Diagnostics.CodeAnalysis.SuppressMessage('PSReviewUnusedParameter', 'PreviousHead')]
[Diagnostics.CodeAnalysis.SuppressMessage('PSReviewUnusedParameter', 'NewHead')]

param(
  [string]$PreviousHead,
  [string]$NewHead,
  [string]$BranchFlag
)

# Only process branch checkouts (flag = 1), not file checkouts (flag = 0)
if ($BranchFlag -ne '1') {
  exit 0
}

Write-Output 'Running PowerShell post-checkout hook.'

# Get the current branch name
try {
  $current_branch = git rev-parse --abbrev-ref HEAD 2>$null
  if ($LASTEXITCODE -ne 0 -or $current_branch -eq 'HEAD') {
    # Not on a branch (detached HEAD), skip processing
    exit 0
  }
}
catch {
  # Error getting branch name, skip processing
  exit 0
}

# Check if the current branch starts with 'local'
if ($current_branch -match '^local($|/)') {
  Write-Output "Switched to local branch '$current_branch'"

  # Check if this branch has upstream set
  try {
    $upstream = git config --get "branch.$current_branch.remote" 2>$null

    if ($null -ne $upstream -and $upstream -ne '' -and $upstream -ne '.') {
      Write-Output "Branch '$current_branch' has upstream set to '$upstream' - unsetting it"

      git branch --unset-upstream $current_branch 2>$null
      if ($LASTEXITCODE -eq 0) {
        Write-Output "Successfully unset upstream for local branch '$current_branch'"
      }
      else {
        Write-Warning "Failed to unset upstream for branch '$current_branch'"
      }
    }
    else {
      Write-Output "Local branch '$current_branch' has no upstream (already clean)"
    }
  }
  catch {
    Write-Warning "Error checking upstream for branch '$current_branch': $_"
  }
}

Write-Output 'Post-checkout checks passed. Proceeding.'
exit 0
