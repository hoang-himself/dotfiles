#!/usr/bin/env bash

function install_base {
  sudo rpm-ostree install buildah git git-lfs neovim avahi nss-mdns qemu-user-static
}

function set_containers {
  ln -frs './configs/containers/systemd' "$XDG_CONFIG_HOME/containers/systemd"
  systemctl --user daemon-reload
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
  set_containers
}

main
