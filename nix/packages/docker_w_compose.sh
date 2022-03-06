#!/usr/bin/env bash

source ./common.sh

function install_compose {
  # local compose_version=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
  # curl -SL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose

  mkdir -p ~/.docker/cli-plugins
  curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose

  chmod +x ~/.docker/cli-plugins/docker-compose
}

function enable_nonroot {
  # https://docs.docker.com/engine/security/rootless/
  sudo "$1" install -y uidmap
  dockerd-rootless-setuptool.sh install
}

echo "No automation, check the following for instructions"
echo "Install Docker Engine: https://docs.docker.com/engine/install/"
echo "Run Dockerd as non-root: https://docs.docker.com/engine/security/rootless/"
echo "Manage Dockerd as non-root: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user"
