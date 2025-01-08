#!/usr/bin/env bash

mkdir -p "$HOME"/.{config,cache,local}
mkdir -p "$HOME"/.config/containers
mkdir -p "$HOME"/.local/{share,state,bin}

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}

function set_base {
  sudo mkdir -p -m 700 '/etc/ssh/sshd_config.d'
  mkdir -p "$HOME"/.ssh/{config.d,id.d,sockets}

  for rc in ../common/config/sshd_config.d/*.conf; do
    [[ -f "$rc" ]] && sudo ln -frs "$rc" "/etc/ssh/sshd_config.d/$(basename "$rc")"
  done

  for rc in ../common/config/ssh_config.d/*.conf; do
    [[ -f "$rc" ]] && sudo ln -frs "$rc" "/etc/ssh/ssh_config.d/$(basename "$rc")"
  done

  ln -frs './config/ssh_config' "$HOME/.ssh/config"

  for file in ../common/config/containers/*.conf; do
    [[ -f "$file" ]] && ln -frs "$file" "$XDG_CONFIG_HOME/containers/$(basename "$file")"
  done
}

function set_shell {
  mkdir -p "$ZDOTDIR/zshrc.d"

  export ZSH="$ZDOTDIR/ohmyzsh"
  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

  export ZSH_CUSTOM="$ZSH/custom"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  ln -frs './runcom/zshenv' "$HOME/.zshenv"

  for rc in ./runcom/*; do
    [[ -f "$rc" ]] && ln -frs "$rc" "$ZDOTDIR/.$(basename "$rc")"
  done

  for rc in ./runcom/zshrc.d/*; do
    [[ -f "$rc" ]] && ln -frs "$rc" "$ZDOTDIR/zshrc.d/$(basename "$rc")"
  done
}

function set_prompt {
  ln -frs '../common/runcom/starship.toml' "$XDG_CONFIG_HOME/starship.toml"
}

function set_runcom {
  ln -frs '../common/config/git' "$XDG_CONFIG_HOME/git"
  ln -frs '../common/runcom/nvim' "$XDG_CONFIG_HOME/nvim"
}

function set_systemd {
  sudo loginctl enable-linger
  ln -frs './config/containers/systemd' "$XDG_CONFIG_HOME/containers/systemd"
  systemctl --user daemon-reload
}
