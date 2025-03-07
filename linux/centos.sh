#!/usr/bin/env bash

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo dnf install -y --skip-broken \
    epel-release epel-next-release
  sudo dnf upgrade -y
  sudo dnf install -y --skip-broken \
    neovim logrotate fail2ban
}

function main {
  install_base
  install_prompt

  set_base
  set_shell
  set_prompt
  set_runcom
  set_systemd
  set_fail2ban
}

main
