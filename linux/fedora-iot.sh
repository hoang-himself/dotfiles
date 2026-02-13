#!/usr/bin/env bash

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo rpm-ostree install --idempotent --reboot -y \
    buildah qemu-user-static zsh \
    git git-lfs neovim logrotate \
    fail2ban
}

function main {
  install_prompt

  set_base
  set_shell
  set_prompt
  set_runcom
  set_systemd
  set_fail2ban
}

main
