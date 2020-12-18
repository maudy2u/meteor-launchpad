#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep METEOR_VERSION $APP_SOURCE_DIR/launchpad.conf)
fi

if [ "$(uname -m)" == "armv7l" ] || [ "$(uname -p)" == "armv7l" ]; then
  printf "\n[-] Installing Meteor 1.3.4.1...\n\n"
  printf "\n[-] *******************************\n\n"
  cd ~
  git clone --depth 1 https://github.com/4commerce-technologies-AG/meteor.git
  ln -sf /root/meteor/meteor /usr/bin/meteor
  meteor --version
elif [ "$(uname -m)" == "aarch64" ] || [ "$(uname -m)" == "arm64" ]; then
  printf "\n[-] Installing Meteor 1.4-universal-beta...\n\n"
  printf "\n[-] *******************************\n\n"
  cd ~
  git clone --depth 1 --branch release-1.4-universal-beta https://github.com/4commerce-technologies-AG/meteor.git
  ln -sf /root/meteor/meteor /usr/bin/meteor
else
  # if not
  if [ -z "${METEOR_VERSION}" ]; then
    # download installer script
    printf "\n[-] Installing Meteor $METEOR_VERSION...\n\n"
    printf "\n[-] *******************************\n\n"
    curl "https://install.meteor.com/?release=$METEOR_VERSION" | sh
    #ln -sf ~/.meteor/meteor /usr/bin/meteor
  else
    # if this is a devbuild, we don't have an app to check the .meteor/release file yet,
    # so just install the latest version of Meteor
    printf "\n[-] Installing the latest version of Meteor...\n\n"
    printf "\n[-] *******************************\n\n"
    curl -v https://install.meteor.com/ | sh
  fi
fi
