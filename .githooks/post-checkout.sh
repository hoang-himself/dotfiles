#!/usr/bin/env bash

# post-checkout hook receives three parameters:
# $1 - previous HEAD
# $2 - new HEAD
# $3 - flag indicating if this was a branch checkout (1) or file checkout (0)

_="$1"
_="$2"
branch_flag="$3"

# Only process branch checkouts (flag = 1), not file checkouts (flag = 0)
if [ "$branch_flag" != "1" ]; then
  exit 0
fi

echo 'Running shell post-checkout hook.'

# Get the current branch name
if ! current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
  # Error getting branch name, skip processing
  exit 0
fi

# Skip if we're in detached HEAD state
if [ "$current_branch" = "HEAD" ]; then
  exit 0
fi

# Check if the current branch starts with 'local'
if [[ "$current_branch" =~ ^local($|/) ]]; then
  echo "Switched to local branch '$current_branch'"

  # Check if this branch has upstream set
  upstream=$(git config --get "branch.$current_branch.remote" 2>/dev/null)

  if [ -n "$upstream" ]; then
    echo "Branch '$current_branch' has upstream set to '$upstream' - unsetting it"

    if git branch --unset-upstream "$current_branch" 2>/dev/null; then
      echo "Successfully unset upstream for local branch '$current_branch'"
    else
      echo "Failed to unset upstream for branch '$current_branch'" >&2
    fi
  else
    echo "Local branch '$current_branch' has no upstream (already clean)"
  fi
fi

echo 'Post-checkout checks passed. Proceeding.'
exit 0
