#!/usr/bin/env bash

set -euo pipefail

branch_name="$1"

[[ ! "$branch_name" =~ ^local($|/) ]] && exit 0

echo -e '\033[31m-----------------------------------------------------\033[0m' >&2
echo -e '\033[31mPUSH REJECTED\033[0m' >&2
echo -e "\033[33mPushing from branch '$branch_name' is not allowed.\033[0m" >&2
echo -e "\033[33mBranches starting with 'local' are restricted from being pushed.\033[0m" >&2
echo -e '\033[31m-----------------------------------------------------\033[0m' >&2
exit 1
