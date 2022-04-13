#!/usr/bin/env bash

function get_distro {
  if [ -r /etc/os-release ]; then
    # Parentheses are needed to run in subshell
    # to avoid polluting the environment
    (. /etc/os-release && echo "$ID")
  fi
}

function createtmp {
  echo "Saving current directory as \$CUR_DIR"
  CUR_DIR=$(pwd)
  TMP_DIR=$(mktemp -d)
  echo "Going to \$TMP_DIR: $TMP_DIR"
  cd "$TMP_DIR" || exit
}

function cleantmp {
  echo "Returning to $CUR_DIR"
  cd "$CUR_DIR" || exit
  echo "Cleaning up $TMP_DIR"
  # Need to add sudo here because git clones leave behind write-protected files
  command sudo rm -r "$TMP_DIR"
}
