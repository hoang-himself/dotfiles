#!/usr/bin/env bash

source ./common.sh

function install_gcc {
  local pre_req=""
  if [[ "$1" == apt ]]; then
    pre_req=(build-essential clang gcc g++ gdb gdbserver rsync zip)
  elif [[ "$1" == dnf ]]; then
    pre_req=(make clang gcc gcc-c++ gdb gdb-gdbserver rsync zip)
  fi
  sudo "$1" install -y "${pre_req[@]}"
}

function install_cmake {
  cmake_version=3.19.4268486
  # Install the Microsoft version of CMake for Visual Studio
  createtmp
  # shellcheck disable=SC2155
  local dist="$(uname -m)"
  if [[ "$dist" == "x86_64" ]]; then
    wget -O cmake.sh "https://github.com/microsoft/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-MSVC_2-Linux-${dist/86_/}.sh"
    sudo bash cmake.sh --skip-license --prefix=/usr/local
  fi
  cleantmp
}

install_gcc "$@"
install_cmake "$@"
