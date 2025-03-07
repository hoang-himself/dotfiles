#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
  echo 'Run script without sudo'
  exit 1
fi

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo dnf upgrade --refresh -y
  sudo dnf install -y --skip-broken \
    util-linux-user git neovim less \
    openssh openssh-clients openssh-server \
    tar buildah podman skopeo zsh
  sudo dnf autoremove -y
}

function main {
  install_base
  install_prompt

  set_base
  set_shell
  set_prompt
  set_runcom
}

main
