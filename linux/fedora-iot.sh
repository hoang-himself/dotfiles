#!/usr/bin/env bash

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo rpm-ostree install buildah git git-lfs neovim avahi nss-mdns qemu-user-static
}

function set_firewall {
  sudo firewall-cmd --permanent --add-service http
  sudo firewall-cmd --permanent --add-service https
  sudo firewall-cmd --permanent --add-service mdns
  sudo firewall-cmd --permanent --add-service ssh
  sudo firewall-cmd --permanent --add-service wireguard
  sudo firewall-cmd --reload
}

function main {
  install_base
  set_systemd
}

main
