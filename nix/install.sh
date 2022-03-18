#!/usr/bin/env bash

./common.sh

function update_upgrade {
  if [[ "$1" == dnf ]]; then
    sudo dnf upgrade -y
  elif [[ "$1" == apt ]]; then
    sudo apt update
    sudo apt full-upgrade -y
  fi
}

function install_packages {
  local pre_req=(acl less most nano pinentry-tty man-db
    make tree curl wget rsync openssl
    dos2unix htop git git-lfs tree gnupg)

  if [[ "$1" == dnf ]]; then
    pre_req+=(dnf-plugins-core crontabs ShellCheck)
  elif [[ "$1" == apt ]]; then
    pre_req+=(apt-utils cron shellcheck)
  fi
  sudo "$1" install -y "${pre_req[@]}"

  sudo update-alternatives --set pinentry "$(command -v pinentry-tty)"
}

function link_config {
  mkdir -p "$HOME"/.{config,cache,local}
  mkdir -p "$HOME"/.local/{share,state,bin}
  mkdir -p "$HOME"/.config/{git,gnupg,ssh,zsh}
  mkdir -p "$HOME"/.ssh/sockets

  export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
  export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
  export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
  export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
  export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
  export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

  chmod 700 "$GNUPGHOME"

  # ln -rs "$@" ./configs/ssh_config "$XDG_CONFIG_HOME"/ssh/config
  ln -rs "$@" ./configs/ssh_config "$HOME"/.ssh/config
  sudo ln -rsf "$@" ./configs/sshd_config /etc/ssh/sshd_config

  ln -rs "$@" ./configs/git/gitconfig "$XDG_CONFIG_HOME"/git/config
  ln -rs "$@" ./configs/git/gitignore.global "$XDG_CONFIG_HOME"/git/ignore.global
  touch "$XDG_CONFIG_HOME"/git/config.local

  for rc_file in ./configs/gnupg/*; do
    ln -rs "$@" "$rc_file" "${XDG_CONFIG_HOME:-$HOME}/gnupg/$(basename "$rc_file")"
  done
}

function main {
  update_upgrade "$@"
  install_packages "$@"
  link_config
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
