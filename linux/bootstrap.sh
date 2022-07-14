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
