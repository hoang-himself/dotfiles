#!/usr/bin/env bash

function update_upgrade {
  if [[ "$1" == dnf ]]; then
    sudo dnf upgrade -y
  elif [[ "$1" == apt ]]; then
    sudo apt update
    sudo apt full-upgrade -y
  fi
}

function base_packages {
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

function zsh_omz {
  sudo "$1" install -y zsh
  
  if [[ "$1" == dnf ]]; then
    lchsh -s "$(command -v zsh)"
  elif [[ "$1" == apt ]]; then
    chsh -s "$(command -v zsh)"
  fi

  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

  local extra_zsh=(ruby cowsay figlet fortune-mod)
  sudo "$1" install -y "${extra_zsh[@]}"
  sudo gem install lolcat
}

function link_config {
  mkdir -p "$HOME"/.{config,cache,local}
  mkdir -p "$HOME"/.local/{share,state,bin}
  mkdir -p "$HOME"/.config/{git,gnupg,ssh,zsh}
  mkdir -p "$HOME"/.ssh/sockets

  # ~/.pam_environment deprecated: https://github.com/linux-pam/linux-pam/releases/tag/v1.5.0
  # cat ./configs/pam_env | sudo tee -a /etc/security/pam_env.conf > /dev/null
  ln "$@" -rs ./runcom/zshenv "$HOME"/.zshenv
  ln "$@" -rs ./runcom/p10k.zsh "$HOME"/.p10k.zsh

  export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
  export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
  export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
  export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
  export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}

  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
  export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

  # ln -rs "$@" ./configs/ssh_config "$XDG_CONFIG_HOME"/ssh/config
  ln -rs "$@" ./configs/ssh_config "$HOME"/.ssh/config
  ln -rs "$@" ./configs/git/gitconfig "$XDG_CONFIG_HOME"/git/config
  ln -rs "$@" ./configs/git/gitignore.global "$XDG_CONFIG_HOME"/git/ignore.global
  touch "$XDG_CONFIG_HOME"/git/config.local

  for rc_file in ./runcom/*; do
    ln -rs "$@" "$rc_file" "${ZDOTDIR:-$HOME}/.$(basename "$rc_file")"
  done

  for rc_file in ./configs/gnupg/*; do
    ln -rs "$@" "$rc_file" "${XDG_CONFIG_HOME:-$HOME}/gnupg/$(basename "$rc_file")"
  done

  chmod 700 "$GNUPGHOME"
}

function do_setup {
  update_upgrade "$@"
  base_packages "$@"
  zsh_omz "$@"
  link_config
  sudo "$1" autoremove -y
}

# https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html
while [[ $# -gt 0 ]]; do
  case "$1" in
  -i | --install)
    if [[ -x "$(command -v apt)" ]]; then
      do_setup apt
    elif [[ -x "$(command -v dnf)" ]]; then
      do_setup dnf
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
