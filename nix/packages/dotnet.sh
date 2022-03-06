#!/usr/bin/env bash

source ./common.sh

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

install_dotnet "$@"
