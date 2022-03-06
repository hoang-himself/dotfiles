#!/usr/bin/env bash

# This script will disable inputting password when you use sudo
# This also means you can `sudo -i` and become root without password

function dangerous {
  if [[ $UID -eq 0 ]]; then
    echo "Looks like you are running this script as root"
    echo "Please run this script without root or sudo"
    echo "We will ask for your password when needed"
    exit 1
  fi

  # To get the current user, this next command must be run as the user
  # shellcheck disable=SC2155
  export USERNAME=$(whoami)

  # shellcheck disable=SC1004
  sudo bash -c 'echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
  && chmod 0440 /etc/sudoers.d/${USERNAME}'

  unset USERNAME
}
