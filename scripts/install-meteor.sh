#!/bin/bash

set -e

if [ "$DEV_BUILD" = true ]; then
  # if this is a devbuild, we don't have an app to check the .meteor/release file yet,
  # so just install the latest version of Meteor
  printf "\n[-] Installing the latest version of Meteor...\n\n"
  curl -v https://install.meteor.com/ | sh
else
  # download installer script
  printf "\n[-] *******************************\n\n"
  printf "\n[-] Installing Meteor $METEOR_VERSION...\n\n"
  printf "\n[-] *******************************\n\n"
  if [ "$(uname -m)" == "armv7l" ] || [ "$(uname -p)" == "armv7l" ]; then
    cd ~
    git clone --depth 1 https://github.com/4commerce-technologies-AG/meteor.git
    cd meteor
    ln -sf ./meteor /usr/bin/meteor
  elif [ "$(uname -m)" == "aarch64" ] || [ "$(uname -m)" == "arm64" ]; then
    cd ~
    git clone --depth 1 --branch release-1.4-universal-beta https://github.com/4commerce-technologies-AG/meteor.git
    cd meteor
    ln -sf ./meteor /usr/bin/meteor
  else
    curl "https://install.meteor.com/?release=1.8.1" | sh
  fi

fi
