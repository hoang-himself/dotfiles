#!/usr/bin/env bash

set -euo pipefail

if ! command -v git-lfs >/dev/null 2>&1; then
  echo -e '\033[31m-----------------------------------------------------\033[0m' >&2
  echo -e '\033[31mGIT LFS NOT FOUND\033[0m' >&2
  echo -e "\033[33mThis repository is configured for Git LFS but 'git-lfs' was not found on your path.\033[0m" >&2
  echo -e "\033[33mIf you no longer wish to use Git LFS, remove this hook by deleting the 'post-commit' file in the hooks directory.\033[0m" >&2
  echo -e '\033[31m-----------------------------------------------------\033[0m' >&2
  exit 2
fi

if ! git lfs ls-files | grep -q .; then
  exit 0
fi

exec git lfs post-commit "$@"
