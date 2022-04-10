#!/usr/bin/env bash

function install_base_packages {
  sudo dnf install dnf-plugins-core util-linux-user -y
  sudo dnf upgrade -y
  sudo dnf install -y git git-lfs less most nano pinentry-tty man-db \
    make curl wget rsync openssl acl gnupg dos2unix htop tree crontabs ShellCheck

  sudo update-alternatives --set pinentry "$(command -v pinentry-tty)"
}

function install_zsh_omz {
  mkdir -p "$HOME"/.config/zsh
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  sudo dnf install -y zsh
  lchsh -s "$(command -v zsh)"

  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

  sudo dnf install -y ruby cowsay figlet fortune-mod
  sudo gem install lolcat

  # ~/.pam_environment deprecated: https://github.com/linux-pam/linux-pam/releases/tag/v1.5.0
  # cat ./configs/pam_env | sudo tee -a /etc/security/pam_env.conf > /dev/null
  ln "$@" -rs ./runcoms/zshenv "$HOME"/.zshenv
  ln "$@" -rs ./runcoms/p10k.zsh "$HOME"/.p10k.zsh

  for file in ./runcoms/*; do
    ln -rs "$@" "$file" "${ZDOTDIR:-$HOME}/.$(basename "$file")"
  done
}

function install_pyenv {
  local python_target="3.10.4"

  sudo dnf install -y dnf install make gcc zlib-devel bzip2 bzip2-devel \
    readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel

  curl -SL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"

  pyenv install -s ${python_target}
  pyenv global ${python_target}

  pip install --upgrade pip setuptools wheel
}

function install_openssh {
  mkdir -p "$HOME/.config/ssh"
  mkdir -p "$HOME/.ssh/sockets"
  sudo mkdir -p "/etc/ssh/keys/$(whoami)"

  sudo dnf install -y openssh-server openssh-clients

  # ln -rs "$@" ./configs/openssh/ssh_config "$XDG_CONFIG_HOME"/ssh/config
  ln -rs "$@" ./configs/openssh/ssh_config "$HOME"/.ssh/config
  # sudo ln -rsf "$@" ./configs/openssh/sshd_config /etc/ssh/sshd_config
}

function link_config {
  ln -rs ./configs/git/gitconfig "$XDG_CONFIG_HOME"/git/config
  ln -rs ./configs/git/gitignore.global "$XDG_CONFIG_HOME"/git/ignore
  # touch "$XDG_CONFIG_HOME"/git/config.local

  export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
  chmod 700 "$GNUPGHOME"
  for file in ./configs/gnupg/*; do
    ln -rs "$@" "$file" "${XDG_CONFIG_HOME:-$HOME}/gnupg/$(basename "$file")"
  done
}

function main {
  mkdir -p "$HOME"/.{config,cache,local}
  mkdir -p "$HOME"/.local/{share,state,bin}
  mkdir -p "$HOME"/.config/{git,gnupg}

  export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
  export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
  export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
  export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
  export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}

  install_base_packages
  install_zsh_omz
  install_pyenv
  install_openssh
  link_config
  sudo dnf autoremove -y
}

main
