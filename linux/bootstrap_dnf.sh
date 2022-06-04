#!/usr/bin/env bash

function install_base {
  sudo dnf install dnf-plugins-core util-linux-user -y
  sudo dnf upgrade -y
  sudo dnf install -y git git-lfs less most nano man-db \
    make curl wget rsync openssl acl gnupg dos2unix htop tree crontabs \
    ShellCheck tldr
  sudo dnf autoremove -y
}

function install_prompt {
  mkdir -p "$HOME/.config/zsh"
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  sudo dnf install -y zsh

  # Use heredoc to automatically press enter on confirmation
  sudo lchsh "$USER" <<EOF
$(command -v zsh)
EOF

  sudo dnf install -y ruby cowsay figlet fortune-mod
  sudo gem install lolcat
}

function install_pyenv {
  sudo dnf install -y make gcc zlib-devel bzip2 bzip2-devel \
    readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel

  curl -SL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
}

function install_openssh {
  sudo dnf install -y openssh-server openssh-clients
}

function install_gcc {
  sudo dnf install -y make clang gcc gcc-c++ gdb gdb-gdbserver rsync zip
}

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
  #local compose_version=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
  #curl -fSL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
  mkdir -p "$HOME/.docker/cli-plugins"
  curl -fSL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o "$HOME/.docker/cli-plugins/docker-compose"
  chmod +x "$HOME/.docker/cli-plugins/docker-compose"
}

function install_haskell {
  sudo dnf install -y haskell-platform
}
