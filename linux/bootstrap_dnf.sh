#!/usr/bin/env bash

function install_base {
  sudo dnf install dnf-plugins-core util-linux-user -y
  sudo dnf upgrade -y
  sudo dnf install -y git git-lfs less most nano man-db \
    make curl wget rsync openssl acl gnupg dos2unix htop tree crontabs \
    ShellCheck tldr zip
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
