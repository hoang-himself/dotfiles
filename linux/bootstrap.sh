#!/usr/bin/env bash

function install_docker_engine {
  # Install Docker Engine: https://docs.docker.com/engine/install/
  curl -fSL https://get.docker.com | bash

  # Run Dockerd as non-root: https://docs.docker.com/engine/security/rootless/
  sudo dnf install -y uidmap
  dockerd-rootless-setuptool.sh install

  # Manage Dockerd as non-root: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
  sudo usermod -aG docker "$(whoami)"
}

function install_docker_compose {
  mkdir -p "$HOME/.docker/cli-plugins"
  curl -fSL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o "$HOME/.docker/cli-plugins/docker-compose"
  chmod +x "$HOME/.docker/cli-plugins/docker-compose"
}

function install_docker_buildx {
  mkdir -p "$HOME/.docker/cli-plugins"
  buildx_version=$(curl --silent "https://api.github.com/repos/docker/buildx/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
  # TODO might move this to ~/raspberrypi because uname -m returns aarch64 instead of arm64
  curl -fSL "https://github.com/docker/buildx/releases/download/${buildx_version}/buildx-${buildx_version}.linux-arm64" \
    -o "$HOME/.docker/cli-plugins/docker-buildx"
  chmod +x "$HOME/.docker/cli-plugins/docker-buildx"
}
