#!/usr/bin/env bash

function link_dotfiles {
  mkdir -p "$HOME"/.{gnupg,ssh}
  ln -frs ./configs/ssh/config ~/.ssh/config

  for rcfile in ./runcom/*; do
    ln -frs "$rcfile" "$HOME/.$(basename "$rcfile")"
  done

  for rcfile in ../common/git/*; do
    ln -frs "$rcfile" "$HOME/.$(basename "$rcfile")"
  done

  for rcfile in ../common/gnupg/*; do
    ln -frs "$rcfile" "$HOME/.gnupg/$(basename "$rcfile")"
  done
}

link_dotfiles
