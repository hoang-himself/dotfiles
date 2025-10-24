#!/usr/bin/env bash

set -euo pipefail

branch_name="$1"

has_upstream() {
  local branch="$1"
  local upstream
  upstream=$(git config --get "branch.$branch.remote" 2>/dev/null || echo "")
  [ -n "$upstream" ] && [ "$upstream" != "." ]
}

unset_upstream() {
  local branch="$1"

  echo "Unsetting upstream for branch '$branch'"

  if git branch --unset-upstream "$branch" 2>/dev/null; then
    echo "Successfully unset upstream for branch '$branch'"
    return 0
  else
    echo "Failed to unset upstream for branch '$branch'" >&2
    return 1
  fi
}

# Only process branches starting with "local" or "local/"
[[ ! "$branch_name" =~ ^local($|/) ]] && exit 0

# Skip if no upstream
has_upstream "$branch_name" || exit 0

echo "Branch '$branch_name' starts with 'local' and has upstream set"
unset_upstream "$branch_name"

exit 0
