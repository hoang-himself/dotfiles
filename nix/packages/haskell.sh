#!/usr/bin/env bash

function install_haskell {
  sudo "$1" install -y haskell-platform
}

install_haskell "$@"
