#!/usr/bin/env bash
if [[ $EUID -eq 0 ]]; then
  echo 'Run script without sudoer'
  exit 1
fi

mkdir -p "$HOME"/.{config,cache,local}
mkdir -p "$HOME"/.local/{share,state,bin}

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}

if [[ -x "$(command -v apt)" ]]; then
  . ./install_apt.sh
elif [[ -x "$(command -v dnf)" ]]; then
  . ./install_dnf.sh
fi

function install_nvm {
  local nvm_ref
  nvm_ref=$(curl --silent 'https://api.github.com/repos/nvm-sh/nvm/releases/latest' | grep -Po '"tag_name": "\K.*?(?=")')
  curl -fSL "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_ref}/install.sh" | bash
}

function set_shell {
  mkdir -p "$ZDOTDIR/zshrc.d"

  export ZSH="$ZDOTDIR/ohmyzsh"
  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

  export ZSH_CUSTOM="$ZSH/custom"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  ln -frs './runcoms/zshenv' "$HOME/.zshenv"
  for rc in ./runcoms/*; do
    [[ -f "$rc" ]] && ln -frs "$rc" "$ZDOTDIR/.$(basename "$rc")"
  done
  for rc in ./runcoms/zshrc.d/*; do
    [[ -f "$rc" ]] && ln -frs "$rc" "$ZDOTDIR/zshrc.d/$(basename "$rc")"
  done
}

function set_prompt {
  ln -frs '../common/runcoms/starship.toml' "$XDG_CONFIG_HOME/starship.toml"
}

function set_openssh {
  sudo mkdir -p -m 700 '/etc/ssh/sshd_config.d'
  sudo mkdir -p -m 700 '/etc/ssh/keys'
  sudo mkdir -p -m 700 "/etc/ssh/keys/$(whoami)"
  mkdir -p "$HOME"/.ssh/{config.d,id.d,sockets}

  for rc in ../common/configs/sshd_config.d/*.conf; do
    [[ -f "$rc" ]] && sudo ln -frs "$rc" "/etc/ssh/sshd_config.d/$(basename "$rc")"
  done
  for rc in ../common/configs/ssh_config.d/*.conf; do
    [[ -f "$rc" ]] && sudo ln -frs "$rc" "/etc/ssh/ssh_config.d/$(basename "$rc")"
  done

  ln -frs './configs/ssh_config' "$HOME/.ssh/config"
}

function set_runcom {
  ln -frs '../common/configs/git' "$XDG_CONFIG_HOME/git"
  ln -frs "../common/runcoms/neovim" "$XDG_CONFIG_HOME/nvim"
}

function set_nvm {
  export NVM_DIR="$XDG_CONFIG_HOME/nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
  nvm install node
  nvm use node
}

function set_containers {
  for file in ../common/configs/containers/*.conf; do
    [[ -f "$file" ]] && ln -frs "$file" "$XDG_CONFIG_HOME/containers/$(basename "$file")"
  done
}

function main {
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
