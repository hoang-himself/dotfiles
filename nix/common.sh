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
  # Install Docker Engine: https://docs.docker.com/engine/install/
  # curl -fSL https://get.docker.com | bash

  # Run Dockerd as non-root: https://docs.docker.com/engine/security/rootless/
  # sudo "$1" install -y uidmap
  # dockerd-rootless-setuptool.sh install

  # Manage Dockerd as non-root: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
  # sudo usermod -aG docker $(whoami)

  # local compose_version=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
  # curl -fSL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose

  mkdir -p ~/.docker/cli-plugins
  curl -fSL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
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

function _dangerous {
  if [[ $UID -eq 0 ]]; then
    echo "Looks like you are running this script as root"
    echo "Please run this script without root or sudo"
    echo "We will ask for your password when needed"
    exit 1
  fi

  echo "$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/00-$(whoami)" > /dev/null
  sudo chmod 0440 "/etc/sudoers.d/00-$(whoami)"

  echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlzVupDIQTLHJibTuOt+mcrRVY35b9yFn0SrAq5cCZ3 baauco@gmail.com' | sudo tee -a "/etc/ssh/keys/$(whoami)/authorized_keys" > /dev/null
  sudo chmod 0600 "/etc/ssh/keys/$(whoami)/authorized_keys"
}
