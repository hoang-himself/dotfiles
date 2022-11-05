#!/usr/bin/env bash

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo rpm-ostree install -y \
    buildah qemu-user-static zsh \
    git git-lfs neovim logrotate fail2ban
}

function install_pyenv {
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
  set_systemd
  set_fail2ban
}

main
