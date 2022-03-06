#!/usr/bin/env bash

function link_dotfiles {
  ln -rs "$@" ./configs/ssh/config ~/.ssh/config

  for rcfile in ./runcom/*; do
    ln -rs "$@" "$rcfile" ~/."$(basename "$rcfile")"
  done

  for rcfile in ../common/git/*; do
    ln -rs "$@" "$rcfile" ~/."$(basename "$rcfile")"
  done

  for rcfile in ../common/gnupg/*; do
    ln -rs "$@" "$rcfile" ~/.gnupg/"$(basename "$rcfile")"
  done
}

link_dotfiles
