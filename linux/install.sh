#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
  echo 'Run script without sudo'
  exit 1
fi

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo dnf upgrade --refresh -y
  sudo dnf install -y --skip-broken \
    util-linux-user git neovim less \
    openssh openssh-clients openssh-server \
    buildah podman skopeo
  sudo dnf autoremove -y
}

function install_shell {
  mkdir -p "$XDG_CONFIG_HOME/zsh"
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  sudo dnf install -y zsh

  chsh -s "$(command -v zsh)"
}

function install_prompt {
  curl -SL https://starship.rs/install.sh | sudo -s sh -s -- -f
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

function main {
  install_base
  install_shell
  install_prompt
  install_pyenv

  set_base
  set_shell
  set_prompt
  set_runcom
}

main
