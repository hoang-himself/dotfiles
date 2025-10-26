#!/usr/bin/env bash

set -euo pipefail

branch_name="$1"

# Only process branches starting with "local" or "local/"
[[ ! "$branch_name" =~ ^local($|/) ]] && exit 0

echo "Unsetting upstream for local branch"

git branch --unset-upstream "$branch_name" 2>/dev/null || true

exit 0
