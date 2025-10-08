Write-Output 'Running PowerShell pre-push hook.'

# Git pipes the remote and local SHAs to the script via standard input.
# The $input variable in PowerShell captures this piped data.
$input | ForEach-Object {
  # <local ref> <local sha> <remote ref> <remote sha>
  $local_ref, $local_sha, $remote_ref, $remote_sha = $_.Split(' ')

  # Skip validation for branch deletions (when local_sha is all zeros)
  if ($local_sha -match '^0+$') {
    $branch_name = $remote_ref -replace '^refs/heads/', ''
    Write-Output "Skipping validation for branch deletion: $branch_name"
    return
  }

  # Extract branch name from local ref (refs/heads/branch-name)
  $branch_name = $local_ref -replace '^refs/heads/', ''

  # Automatically unset upstream for local branches
  & '.\.githooks\pre-push.d\assert-local-has-upstream.ps1' $branch_name

  # Modular branch name check
  & '.\.githooks\pre-push.d\assert-branch-is-local.ps1' $branch_name
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  # If the remote ref is all zeros, it's a new branch being pushed
  if ($remote_sha -match '^0+$') {
    $commit_range = $local_sha
  }
  else {
    $commit_range = "$remote_sha..$local_sha"
  }

  # Modular commit message check
  & '.\.githooks\pre-push.d\assert-commit-is-local.ps1' $commit_range
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

Write-Output 'Pre-push checks passed. Proceeding.'
exit 0
