#!/usr/bin/env bash

set -euo pipefail

# remote_name="$1"
# remote_url="$2"

# patterns=(
#   'blocked|github.com/hoang-himself/'
#   'allowed|github.com:hoang-himself/'
#   'blocked|gitlab.com/hoang-himself/'
#   'allowed|gitlab.com:hoang-himself/'
#   'blocked|*'
# )

# policy=''

# for pattern_entry in "${patterns[@]}"; do
#   type="${pattern_entry%|*}"
#   pattern="${pattern_entry#*|}"

#   if [[ "$remote_url" == *"$pattern"* ]]; then
#     policy="$type"
#     break
#   fi
# done

# if [[ -z "$policy" ]] || [[ "$policy" == 'blocked' ]]; then
#   echo -e '\033[31m-----------------------------------------------------\033[0m' >&2
#   echo -e '\033[31mPUSH REJECTED\033[0m' >&2
#   echo -e "\033[33mPushing to $remote_name <$remote_url> is not allowed.\033[0m" >&2
#   echo -e '\033[31m-----------------------------------------------------\033[0m' >&2
#   exit 1
# fi
