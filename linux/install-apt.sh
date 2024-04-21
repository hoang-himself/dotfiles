#!/usr/bin/env bash
if [[ $EUID -eq 0 ]]; then
  echo 'Run script without sudoer'
  exit 1
fi

if ! command -v apt &>/dev/null; then
  echo 'apt not found'
  exit 1
fi

#shellcheck source=./common.sh
. ./common.sh

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

function main {
  set_xdg_dir

  install_base
  install_shell
  install_prompt

  install_containers
  install_pyenv

  set_shell
  set_prompt
  set_openssh
  set_runcom
}

main
