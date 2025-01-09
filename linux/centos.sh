#!/usr/bin/env bash

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo dnf install -y --skip-broken \
    epel-release epel-next-release
  sudo dnf upgrade -y
  sudo dnf install -y --skip-broken neovim
}

function set_firewall {
  sudo systemctl enable --now firewalld
  sudo firewall-cmd --permanent --add-service http
  sudo firewall-cmd --permanent --add-service https
  sudo firewall-cmd --permanent --add-service ssh
  sudo firewall-cmd --permanent --add-service wireguard
  sudo firewall-cmd --reload
}

function main {
  install_base
  set_systemd
}

main
