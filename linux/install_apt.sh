#!/usr/bin/env bash

function install_base {
  sudo apt update
  sudo apt install -y apt-utils build-essential
  sudo apt full-upgrade -y
  sudo apt install -y git git-lfs less neovim make curl wget rsync \
    openssl acl gnupg dos2unix cron shellcheck \
    openssh-client #openssh-server
  sudo apt autoremove -y
}

function install_shell {
  mkdir -p "$XDG_CONFIG_HOME/zsh"
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  sudo apt install -y zsh
  chsh -s "$(command -v zsh)"
}

function install_prompt {
  curl -SL https://starship.rs/install.sh | sudo sh -s -- -f
}

function install_containers {
  sudo apt install -y buildah podman skopeo
}

function install_pyenv {
  sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  curl -SL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
}
