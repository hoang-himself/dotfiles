#!/usr/bin/env bash

function install_base {
  sudo apt update
  sudo apt install -y apt-utils build-essential
  sudo apt full-upgrade -y
  sudo apt install -y git git-lfs less most nano man-db \
    make curl wget rsync openssl acl gnupg dos2unix htop tree cron \
    shellcheck tldr zip
  sudo apt autoremove -y
}

function install_prompt {
  mkdir -p "$HOME/.config/zsh"
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  sudo apt install -y zsh
  chsh -s "$(command -v zsh)"

  sudo apt install -y ruby cowsay figlet fortune-mod
  sudo gem install lolcat
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

function install_openssh {
  sudo apt install -y openssh-server openssh-client
}
