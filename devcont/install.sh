#!/usr/bin/env bash

function link_dotfiles {
  for rcfile in ./runcom/*; do
    ln -frs "$rcfile" "$HOME/.$(basename "$rcfile")"
  done
}

link_dotfiles
