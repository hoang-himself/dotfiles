#!/usr/bin/env bash

set -euo pipefail

commit_range="$1"
offending_commits=$(git log --pretty='format:%H:%s' "$commit_range" | grep -E '^[^:]+:local(\W.*)?' || true)

[ -z "$offending_commits" ] && exit 0

echo -e '\033[31m-----------------------------------------------------\033[0m' >&2
echo -e '\033[31mPUSH REJECTED\033[0m' >&2
echo -e "\033[33mYour push contains commits prefixed with 'local', which are not allowed.\033[0m" >&2
echo -e '\033[33mPlease rebase interactively (git rebase -i) to rename or remove them.\033[0m' >&2
echo '' >&2
echo -e '\033[33mOffending commits found:\033[0m' >&2
echo "$offending_commits" | while IFS=':' read -r sha subject; do
  short_sha="${sha:0:9}"
  echo "  - $short_sha: $subject" >&2
done
echo -e '\033[31m-----------------------------------------------------\033[0m' >&2
exit 1
