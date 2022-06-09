#!/usr/bin/env bash

mkdir -p "$HOME"/.{config,cache,local}
mkdir -p "$HOME"/.local/{share,state,bin}
mkdir -p "$HOME"/.config/{git,gnupg}

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}

if [[ -x "$(command -v apt)" ]]; then
  . ./bootstrap_apt.sh
elif [[ -x "$(command -v dnf)" ]]; then
  . ./bootstrap_dnf.sh
fi

function set_prompt {
  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
  curl -SL https://starship.rs/install.sh | sh -s -- -f
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

  # ~/.pam_environment deprecated: https://github.com/linux-pam/linux-pam/releases/tag/v1.5.0
  # cat ./configs/pam_env | sudo tee -a /etc/security/pam_env.conf > /dev/null
  ln -frs './runcoms/zshenv' "$HOME/.zshenv"

  for file in ./runcoms/*; do
    ln -frs "$file" "$ZDOTDIR/.$(basename "$file")"
  done
  ln -frs '../global/runcoms/starship.toml' "$XDG_CONFIG_HOME/starship.toml"
  mkdir -p "$ZDOTDIR/.zshrc.d"
}

function set_pyenv {
  pyenv update
  local python_target='3.10.4'
  pyenv install -s "$python_target"
  pyenv global "$python_target"
  pip install --upgrade pip setuptools wheel
}

function set_openssh {
  sudo mkdir -p '/etc/ssh/sshd_config.d'
  sudo mkdir -p "/etc/ssh/keys/$(whoami)"
  mkdir -p "$HOME/.ssh/config.d"
  mkdir -p "$HOME/.ssh/sockets"

  sudo ln -frs './configs/openssh/sshd_config' '/etc/ssh/sshd_config'
  ln -frs './configs/openssh/ssh_config' "$HOME/.ssh/config"
}

function set_config {
  ln -frs './configs/git/gitconfig' "$XDG_CONFIG_HOME/git/config"
  ln -frs '../global/configs/git/gitignore.global' "$XDG_CONFIG_HOME/git/ignore"
  ln -frs '../global/configs/git/gitmessage' "$HOME/.gitmessage"
  touch "$HOME/.gitconfig.local"

  mkdir -p "$HOME/.gnupg"
  chmod 700 "$HOME/.gnupg"
  for file in ./configs/gnupg/*; do
    ln -frs "$file" "$HOME/.gnupg/$(basename "$file")"
  done
}

function main {
  install_base
  install_prompt && set_prompt
  install_pyenv && set_pyenv
  install_openssh && set_openssh
  set_config
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -i | --install)
    main
    shift
    ;;
  *)
    echo "Unrecognized option \"$1\""
    shift
    ;;
  esac
done
