#!/usr/bin/env bash

function set_containers {
  ln -frs '../common/configs/containers/systemd' "$XDG_CONFIG_HOME/containers/systemd"
  systemctl --user daemon-reload
}

function set_firewall {
  sudo firewall-cmd --permanent --add-service http
  sudo firewall-cmd --permanent --add-service https
  sudo firewall-cmd --permanent --add-service ssh
  sudo firewall-cmd --permanent --add-service wireguard
  sudo firewall-cmd --reload
}

function main {
  set_containers
}

main
