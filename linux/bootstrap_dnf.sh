#!/usr/bin/env bash

function install_base_package {
  sudo dnf install dnf-plugins-core util-linux-user -y
  sudo dnf upgrade -y
  sudo dnf install -y git git-lfs less most nano pinentry-tty man-db \
    make curl wget rsync openssl acl gnupg dos2unix htop tree crontabs \
    ShellCheck tldr

  sudo update-alternatives --set pinentry "$(command -v pinentry-tty)"
}

function install_prompt {
  mkdir -p "$HOME"/.config/zsh
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  sudo dnf install -y zsh
  sudo lchsh "$USER" <<EOF
$(command -v zsh)
EOF

  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  curl -SL https://starship.rs/install.sh | sh -s -- -f
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

  sudo dnf install -y ruby cowsay figlet fortune-mod
  sudo gem install lolcat

  # ~/.pam_environment deprecated: https://github.com/linux-pam/linux-pam/releases/tag/v1.5.0
  # cat ./configs/pam_env | sudo tee -a /etc/security/pam_env.conf > /dev/null
  ln -frs ./runcoms/zshenv "$HOME"/.zshenv
  ln -frs ./runcoms/p10k.zsh "$HOME"/.p10k.zsh

  for file in ./runcoms/*; do
    ln -frs "$file" "${ZDOTDIR:-$HOME}/.$(basename "$file")"
  done
}

function install_pyenv {
  sudo dnf install -y make gcc zlib-devel bzip2 bzip2-devel \
    readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel

  curl -SL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"

  pyenv update
  pyenv install -s "$_PYTHON_TARGET"
  pyenv global "$_PYTHON_TARGET"
  pip install --upgrade pip setuptools wheel
}

function install_openssh {
  mkdir -p "$HOME/.config/ssh"
  mkdir -p "$HOME/.ssh/sockets"
  sudo mkdir -p "/etc/ssh/keys/$(whoami)"

  sudo dnf install -y openssh-server openssh-clients

  # ln -frs ./configs/openssh/ssh_config "$XDG_CONFIG_HOME"/ssh/config
  ln -frs ./configs/openssh/ssh_config "$HOME"/.ssh/config
  # sudo ln -frs ./configs/openssh/sshd_config /etc/ssh/sshd_config
}

function install_gcc {
  sudo dnf install -y make clang gcc gcc-c++ gdb gdb-gdbserver rsync zip
}

function install_docker_engine {
  # Install Docker Engine: https://docs.docker.com/engine/install/
  curl -fSL https://get.docker.com | bash

  # Run Dockerd as non-root: https://docs.docker.com/engine/security/rootless/
  sudo dnf install -y uidmap
  dockerd-rootless-setuptool.sh install

  # Manage Dockerd as non-root: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
  sudo usermod -aG docker "$(whoami)"
}

function install_compose_v2 {
  #local compose_version=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
  #curl -fSL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
  mkdir -p ~/.docker/cli-plugins
  curl -fSL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
  chmod +x ~/.docker/cli-plugins/docker-compose
}

function install_haskell {
  sudo dnf install -y haskell-platform
}

function link_config {
  ln -frs ./configs/git/gitconfig "$XDG_CONFIG_HOME"/git/config
  ln -frs ./configs/git/gitignore.global "$XDG_CONFIG_HOME"/git/ignore
  # touch "$XDG_CONFIG_HOME"/git/config.local

  export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
  chmod 700 "$GNUPGHOME"
  for file in ./configs/gnupg/*; do
    ln -frs "$file" "${XDG_CONFIG_HOME:-$HOME}/gnupg/$(basename "$file")"
  done
}

function main {
  install_base_package
  install_prompt
  install_pyenv
  install_openssh
  link_config
  sudo dnf autoremove -y
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -i | --install)
    main
    shift
    ;;
  *)
    echo Unrecognized option \`"$1"\'
    shift
    ;;
  esac
done
