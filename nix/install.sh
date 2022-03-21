#!/usr/bin/env bash

. ./common.sh

function install_packages {
  local pre_req=(acl less most nano pinentry-tty man-db
    make tree curl wget rsync openssl
    dos2unix htop git git-lfs tree gnupg)

  if [[ "$1" == dnf ]]; then
    sudo dnf install dnf-plugins-core util-linux-user -y
    sudo dnf upgrade -y
    pre_req+=(crontabs ShellCheck)
  elif [[ "$1" == apt ]]; then
    sudo apt update
    sudo apt install apt-utils -y
    sudo apt full-upgrade -y
    pre_req+=(cron shellcheck)
  fi

  sudo "$1" install -y "${pre_req[@]}"

  sudo update-alternatives --set pinentry "$(command -v pinentry-tty)"
}

function install_zsh_omz {
  mkdir -p "$HOME"/.config/zsh
  sudo "$1" install -y zsh

  chsh -s "$(command -v zsh)"

  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

  local extra=(ruby cowsay figlet fortune-mod)
  sudo "$1" install -y "${extra[@]}"
  sudo gem install lolcat
}

function install_openssh {
  mkdir -p "$HOME"/.config/ssh
  mkdir -p "$HOME"/.ssh/sockets

  local pre_req=(openssh-server)
  if [[ "$1" == apt ]]; then
    pre_req+=(openssh-client)
  elif [[ "$1" == dnf ]]; then
    pre_req+=(openssh-clients)
  fi
  sudo "$1" install -y "${pre_req[@]}"
}

function link_config {
  mkdir -p "$HOME"/.{config,cache,local}
  mkdir -p "$HOME"/.local/{share,state,bin}
  mkdir -p "$HOME"/.config/{git,gnupg}

  export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
  export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
  export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
  export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
  export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}

  export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  chmod 700 "$GNUPGHOME"
  ln -rs "$@" ./configs/git/gitconfig "$XDG_CONFIG_HOME"/git/config
  ln -rs "$@" ./configs/git/gitignore.global "$XDG_CONFIG_HOME"/git/ignore
  touch "$XDG_CONFIG_HOME"/git/config.local

  for file in ./configs/gnupg/*; do
    ln -rs "$@" "$file" "${XDG_CONFIG_HOME:-$HOME}/gnupg/$(basename "$file")"
  done

  # ~/.pam_environment deprecated: https://github.com/linux-pam/linux-pam/releases/tag/v1.5.0
  # cat ./configs/pam_env | sudo tee -a /etc/security/pam_env.conf > /dev/null
  ln "$@" -rs ./runcoms/zshenv "$HOME"/.zshenv
  ln "$@" -rs ./runcoms/p10k.zsh "$HOME"/.p10k.zsh

  for file in ./runcoms/*; do
    ln -rs "$@" "$file" "${ZDOTDIR:-$HOME}/.$(basename "$file")"
  done

  # ln -rs "$@" ./configs/ssh_config "$XDG_CONFIG_HOME"/ssh/config
  ln -rs "$@" ./configs/ssh_config "$HOME"/.ssh/config
  sudo ln -rsf "$@" ./configs/sshd_config /etc/ssh/sshd_config
}

function main {
  install_packages "$@"
  install_openssh "$@"
  install_zsh_omz "$@"
  link_config
  sudo "$1" autoremove -y
}

# https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html
while [[ $# -gt 0 ]]; do
  case "$1" in
  -i | --install)
    if [[ -x "$(command -v apt)" ]]; then
      main apt
    elif [[ -x "$(command -v dnf)" ]]; then
      main dnf
    fi
    shift
    ;;
  --df)
    link_config -f
    shift
    ;;
  *)
    echo Unrecognized option \`"$1"\'
    shift
    ;;
  esac
done
