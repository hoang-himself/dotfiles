#!/usr/bin/env bash

function get_distro {
  local lsb_dist=""
  if [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID")"
  fi
  echo "$lsb_dist"
}

function createtmp {
  echo "Saving current directory as \$CUR_DIR"
  CUR_DIR=$(pwd)
  TMP_DIR=$(mktemp -d)
  echo "Going to \$TMP_DIR: $TMP_DIR"
  cd "$TMP_DIR" || exit
}

function cleantmp {
  echo "Returning to $CUR_DIR"
  cd "$CUR_DIR" || exit
  echo "Cleaning up $TMP_DIR"
  # Need to add sudo here because git clones leave behind write-protected files
  command sudo rm -r "$TMP_DIR"
}

function install_zsh_omz {
  mkdir -p "$HOME"/.config/zsh
  sudo "$1" install -y zsh

  if [[ "$1" == dnf ]]; then
    lchsh -s "$(command -v zsh)"
  elif [[ "$1" == apt ]]; then
    chsh -s "$(command -v zsh)"
  fi

  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  curl -SL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

  local extra_zsh=(ruby cowsay figlet fortune-mod)
  sudo "$1" install -y "${extra_zsh[@]}"
  sudo gem install lolcat

  # ~/.pam_environment deprecated: https://github.com/linux-pam/linux-pam/releases/tag/v1.5.0
  # cat ./configs/pam_env | sudo tee -a /etc/security/pam_env.conf > /dev/null
  ln "$@" -rs ./runcoms/zshenv "$HOME"/.zshenv
  ln "$@" -rs ./runcoms/p10k.zsh "$HOME"/.p10k.zsh

  for rc_file in ./runcoms/*; do
    ln -rs "$@" "$rc_file" "${ZDOTDIR:-$HOME}/.$(basename "$rc_file")"
  done
}

function install_openssh {
  mkdir -p "$HOME"/.config/ssh
  mkdir -p "$HOME"/.ssh/sockets

  local pre_req=(openssh-server)
  if [[ "$1" == apt ]]; then
    pre_req+=(openssh-client)
  elif [[ "$1" == dnf ]]; then
    pre_req+=(openssh-clients)
  fi
  sudo "$1" install -y "${pre_req[@]}"

  # ln -rs "$@" ./configs/ssh_config "$XDG_CONFIG_HOME"/ssh/config
  ln -rs "$@" ./configs/ssh_config "$HOME"/.ssh/config
  sudo ln -rsf "$@" ./configs/sshd_config /etc/ssh/sshd_config
}

function install_gcc {
  local pre_req=("")
  if [[ "$1" == apt ]]; then
    pre_req=(build-essential clang gcc g++ gdb gdbserver rsync zip)
  elif [[ "$1" == dnf ]]; then
    pre_req=(make clang gcc gcc-c++ gdb gdb-gdbserver rsync zip)
  fi
  sudo "$1" install -y "${pre_req[@]}"
}

function install_static_cmake {
  cmake_version=3.19.4268486
  # Install the Microsoft version of CMake for Visual Studio
  # shellcheck disable=SC2155
  local dist="$(uname -m)"
  if [[ "$dist" == "x86_64" ]]; then
    createtmp
    wget -O cmake.sh "https://github.com/microsoft/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-MSVC_2-Linux-${dist/86_/}.sh"
    sudo bash cmake.sh --skip-license --prefix=/usr/local
    cleantmp
  fi
}

function install_docker_compose {
  # "Install Docker Engine: https://docs.docker.com/engine/install/"
  # "Run Dockerd as non-root: https://docs.docker.com/engine/security/rootless/"
  # "Manage Dockerd as non-root: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user"

  # local compose_version=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
  # curl -SL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose

  mkdir -p ~/.docker/cli-plugins
  curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose

  chmod +x ~/.docker/cli-plugins/docker-compose
}

function install_dotnet {
  local dotnet_version="6.0"
  if [[ "$1" == apt ]]; then
    createtmp
    wget "https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb" -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    cleantmp
  fi

  sudo "$1" install -y dotnet-sdk-${dotnet_version} nuget
}

function install_haskell {
  sudo "$1" install -y haskell-platform
}

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

  # npm install -g gitmoji-cli
}

function install_pyenv {
  local pre_req=("")
  local python_target="3.10.2"

  if [[ -x "$(command -v pyenv)" ]]; then
    pyenv update
  else
    if [[ "$1" == apt ]]; then
      pre_req=(apt-utils build-essential curl libbz2-dev libffi-dev liblzma-dev
        libncursesw5-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev
        libxmlsec1-dev llvm make tk-dev wget xz-utils zlib1g-dev)
    elif [[ "$1" == dnf ]]; then
      pre_req=(bzip2 bzip2-devel gcc libffi-devel make openssl-devel readline-devel
        sqlite sqlite-devel tk-devel xz-devel zlib-devel util-linux-user)
    fi

    sudo "$1" install -y "${pre_req[@]}"

    curl -SL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
  fi

  pyenv install -s ${python_target}
  pyenv global ${python_target}

  pip install --upgrade pip setuptools wheel
}

function enable_passwordless_sudo {
  # This script will disable inputting password when you use sudo
  # This also means you can `sudo -i` and become root without password

  if [[ $UID -eq 0 ]]; then
    echo "Looks like you are running this script as root"
    echo "Please run this script without root or sudo"
    echo "We will ask for your password when needed"
    exit 1
  fi

  # To get the current user, this next command must be run as the user
  # shellcheck disable=SC2155
  export USERNAME=$(whoami)

  # shellcheck disable=SC1004
  sudo bash -c 'echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
  && chmod 0440 /etc/sudoers.d/${USERNAME}'

  unset USERNAME
}
