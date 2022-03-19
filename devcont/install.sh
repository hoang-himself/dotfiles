#!/usr/bin/env bash

function link_dotfiles {
  mkdir -p "$HOME"/.{gnupg,ssh}
  ln -rs "$@" ./configs/ssh/config ~/.ssh/config

  for rcfile in ./runcom/*; do
    ln -rs "$@" "$rcfile" "$HOME/.$(basename "$rcfile")"
  done

  for rcfile in ../common/git/*; do
    ln -rs "$@" "$rcfile" "$HOME/.$(basename "$rcfile")"
  done

  for rcfile in ../common/gnupg/*; do
    ln -rs "$@" "$rcfile" "$HOME/.gnupg/$(basename "$rcfile")"
  done
}

link_dotfiles
