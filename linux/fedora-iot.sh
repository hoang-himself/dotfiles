#!/usr/bin/env bash

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo rpm-ostree kargs --delete-if-present '$ignition_firstboot'
  sudo rpm-ostree install -y \
    buildah qemu-user-static avahi nss-mdns \
    git git-lfs neovim logrotate fail2ban
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
  set_fail2ban
}

main
