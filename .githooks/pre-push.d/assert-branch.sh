#!/usr/bin/env bash

branch_name="$1"

if [[ "$branch_name" =~ ^local($|/) ]]; then
  echo -e '\033[31m-----------------------------------------------------\033[0m'
  echo -e '\033[31m PUSH REJECTED\033[0m'
  echo -e "\033[33m Pushing from branch '$branch_name' is not allowed.\033[0m"
  echo -e '\033[33m Branches starting with '"'"'local'"'"' are restricted from being pushed.\033[0m'
  echo -e '\033[31m-----------------------------------------------------\033[0m'
  exit 1
fi
