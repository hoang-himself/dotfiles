#!/usr/bin/env bash

#shellcheck source=./common.sh
. ./common.sh

function set_firewall {
  sudo firewall-cmd --permanent --add-service http
  sudo firewall-cmd --permanent --add-service https
  sudo firewall-cmd --permanent --add-service ssh
  sudo firewall-cmd --permanent --add-service wireguard
  sudo firewall-cmd --reload
}

function main {
  set_systemd
}

main
