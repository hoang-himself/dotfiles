#!/usr/bin/env bash

function install_zsh {
  sudo "$1" install -y zsh
  chsh -s "$(command -v zsh)"

  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  
  ln "$@" -rs ./runcom/p10k.zsh "$HOME"/.p10k.zsh

  local extra_zsh=(ruby cowsay figlet fortune-mod)
  sudo "$1" install -y "${extra_zsh[@]}"
  sudo gem install lolcat
}

install_zsh "$@"
