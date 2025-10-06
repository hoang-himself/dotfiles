param([string]$BranchName)

if ($BranchName -match '^local($|/)') {
  Write-Warning '-----------------------------------------------------'
  Write-Warning ' PUSH REJECTED'
  Write-Warning " Pushing from branch '$BranchName' is not allowed."
  Write-Warning " Branches starting with 'local' are restricted from being pushed."
  Write-Warning '-----------------------------------------------------'
  exit 1
}
