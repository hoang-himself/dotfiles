#!/usr/bin/env bash

set -euo pipefail

branch_flag="$3"

# Only process branch checkouts
[ "$branch_flag" != "1" ] && exit 0

current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

# Skip if no branch or detached HEAD
[ -z "$current_branch" ] || [ "$current_branch" = "HEAD" ] && exit 0

# Only process branches starting with "local" or "local/"
[[ ! "$current_branch" =~ ^local($|/) ]] && exit 0

echo "Unsetting upstream for local branch"

git branch --unset-upstream "$current_branch" 2>/dev/null || true

exit 0
