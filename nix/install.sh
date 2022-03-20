#!/usr/bin/env bash

. ./common.sh

function install_packages {
  local pre_req=(acl less most nano pinentry-tty man-db
    make tree curl wget rsync openssl
    dos2unix htop git git-lfs tree gnupg)

  if [[ "$1" == dnf ]]; then
    sudo dnf install dnf-plugins-core -y
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

  chmod 700 "$GNUPGHOME"

  ln -rs "$@" ./configs/git/gitconfig "$XDG_CONFIG_HOME"/git/config
  ln -rs "$@" ./configs/git/gitignore.global "$XDG_CONFIG_HOME"/git/ignore.global
  touch "$XDG_CONFIG_HOME"/git/config.local

  for rc_file in ./configs/gnupg/*; do
    ln -rs "$@" "$rc_file" "${XDG_CONFIG_HOME:-$HOME}/gnupg/$(basename "$rc_file")"
  done
}

function main {
  install_packages "$@"
  link_config
  install_openssh "$@"
  install_zsh_omz "$@"
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
