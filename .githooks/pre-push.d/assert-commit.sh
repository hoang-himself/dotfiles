#!/usr/bin/env bash

commit_range="$1"
offending_commits=$(git log --pretty='format:%H:%s' "$commit_range" | grep -E '^[^:]+:local(\W.*)?')

if [ -n "$offending_commits" ]; then
  echo -e '\033[31m-----------------------------------------------------\033[0m'
  echo -e '\033[31m PUSH REJECTED\033[0m'
  echo -e "\033[33m Your push contains commits prefixed with 'local', which are not allowed.\033[0m"
  echo -e '\033[33m Please rebase interactively (git rebase -i) to rename or remove them.\033[0m'
  echo ''
  echo -e '\033[33m Offending commits found:\033[0m'
  echo "$offending_commits" | while read -r line; do
    sha=$(echo "$line" | cut -d':' -f1)
    subject=$(echo "$line" | cut -d':' -f2-)
    short_sha=$(echo "$sha" | cut -c1-9)
    echo " - $short_sha:$subject"
  done
  echo -e '\033[31m-----------------------------------------------------\033[0m'
  exit 1
fi
