#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC2034
previous_head="$1"
# shellcheck disable=SC2034
new_head="$2"
branch_flag="$3"

# Only process branch checkouts
[ "$branch_flag" != "1" ] && exit 0

current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# Skip if no branch or detached HEAD
[ -z "$current_branch" ] || [ "$current_branch" = "HEAD" ] && exit 0

# Only process branches starting with "local" or "local/"
[[ ! "$current_branch" =~ ^local($|/) ]] && exit 0

echo "Switched to local branch '$current_branch'"

upstream=$(git config --get "branch.$current_branch.remote" 2>/dev/null || echo "")

# Skip if no upstream or upstream is local
[ -z "$upstream" ] || [ "$upstream" = "." ] && exit 0

echo "Unsetting upstream '$upstream' for local branch"

if git branch --unset-upstream "$current_branch" 2>/dev/null; then
  echo 'Successfully unset upstream'
else
  echo 'Failed to unset upstream' >&2
  exit 1
fi

exit 0
