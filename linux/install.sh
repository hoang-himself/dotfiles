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
    tar buildah podman skopeo zsh
  sudo dnf autoremove -y
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
  install_prompt
  install_pyenv

  set_base
  set_shell
  set_prompt
  set_runcom
}

main
