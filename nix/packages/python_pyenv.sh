#!/usr/bin/env bash

function install_pyenv {
  local pre_req=""
  local python_target="3.10.0"

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

install_pyenv "$@"
