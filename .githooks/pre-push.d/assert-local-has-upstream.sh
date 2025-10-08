#!/usr/bin/env bash

branch_name="$1"

has_upstream() {
  local branch="$1"
  upstream=$(git config --get "branch.$branch.remote" 2>/dev/null)
  [ -n "$upstream" ]
}

unset_upstream() {
  local branch="$1"

  echo "Unsetting upstream for branch '$branch'."

  if git branch --unset-upstream "$branch" 2>/dev/null; then
    echo "Successfully unset upstream for branch '$branch'"
    return 0
  else
    echo "Failed to unset upstream for branch '$branch'" >&2
    return 1
  fi
}

if [[ "$branch_name" =~ ^local($|/) ]]; then
  if has_upstream "$branch_name"; then
    echo "Branch '$branch_name' starts with 'local' and has upstream set."
    unset_upstream "$branch_name"
  fi
fi

exit 0
