param([string]$CommitRange)

$offending_commits = git log --pretty='format:%H:%s' $CommitRange | Where-Object { $_ -match '^[^:]+:local(\W.*)?' }

if ($null -ne $offending_commits) {
  Write-Warning '-----------------------------------------------------'
  Write-Warning ' PUSH REJECTED'
  Write-Warning " Your push contains commits prefixed with 'local', which are not allowed."
  Write-Warning ' Please rebase interactively (git rebase -i) to rename or remove them.'
  Write-Warning ''
  Write-Warning ' Offending commits found:'
  foreach ($line in $offending_commits) {
    $sha = $line.Split(':')[0].Substring(0, 9)
    $subject = $line.Substring($line.IndexOf(':'))
    Write-Output " - $sha$subject"
  }
  Write-Warning '-----------------------------------------------------'
  exit 1
}
