#!/usr/bin/env bash

mkdir -p "$HOME"/.{config,cache,local}
mkdir -p "$HOME"/.local/{share,state,bin}
mkdir -p "$HOME"/.config/{git,gnupg}

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}

export _PYTHON_TARGET='3.10.4'
if [[ -x "$(command -v apt)" ]]; then
  ./bootstrap_apt.sh -i
elif [[ -x "$(command -v dnf)" ]]; then
  ./bootstrap_dnf.sh -i
fi
unset _PYTHON_TARGET
