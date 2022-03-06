#!/usr/bin/env bash

function install_node {
  if [[ -x "$(command -v n)" ]]; then
    n-update -y
  else
    curl -SL https://git.io/n-install | bash -s -- -y
    export N_PREFIX="$HOME/n"
    [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
  fi

  n latest
  n prune

  # npm install -g editorconfig gitmoji-cli
}

install_node "$@"
