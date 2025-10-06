#!/usr/bin/env bash

echo 'Running shell pre-push hook.'

# Git pipes the remote and local SHAs to the script via standard input.
# Read each line from stdin.
while read -r local_ref local_sha remote_ref remote_sha; do
  # Skip validation for branch deletions (when local_sha is all zeros)
  if [[ "$local_sha" =~ ^0+$ ]]; then
    echo "Skipping validation for branch deletion: ${remote_ref#refs/heads/}"
    continue
  fi

  # Extract branch name from local ref (refs/heads/branch-name)
  branch_name="${local_ref#refs/heads/}"

  # Modular branch name check
  ./.githooks/pre-push.d/assert-branch.sh "$branch_name"
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    exit $exit_code
  fi

  # If the remote ref is all zeros, it's a new branch being pushed
  if [[ "$remote_sha" =~ ^0+$ ]]; then
    commit_range="$local_sha"
  else
    commit_range="$remote_sha..$local_sha"
  fi

  # Modular commit message check
  ./.githooks/pre-push.d/assert-commit.sh "$commit_range"
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    exit $exit_code
  fi
done

echo 'Pre-push checks passed. Proceeding.'
exit 0
