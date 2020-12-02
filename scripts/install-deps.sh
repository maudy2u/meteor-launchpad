#!/bin/bash

set -e

printf "\n[-] Installing base OS dependencies...\n\n"

# install base dependencies

apt-get update

# ensure we can get an https apt source if redirected
# https://github.com/jshimko/meteor-launchpad/issues/50
apt-get install -y apt-transport-https ca-certificates

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep APT_GET_INSTALL $APP_SOURCE_DIR/launchpad.conf)
  source <(grep TZ $APP_SOURCE_DIR/launchpad.conf)

  if [ "${APT_GET_INSTALL}" ]; then
    printf "\n[-] Installing custom apt dependencies...\n\n"
    apt-get install -y $APT_GET_INSTALL
  fi
  if [ -z "$TZ" ]; then
    TZ=America/Moncton; export TZ
  fi
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

apt-get install -y --no-install-recommends curl tzdata jq wget bzip2 bsdtar build-essential python gnupg


# install gosu
printf "\n[-] ******************************* \n\n"
printf "\n[-] ADD BACK IN THE sig check for GOSU...\n\n"
printf "\n[-] ******************************* \n\n"

# dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"
# wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
# wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"

# export GNUPGHOME="$(mktemp -d)"
#
# gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
# gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
#
# rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc
# printf "\n[-] ******************************* \n\n"
#
# chmod +x /usr/local/bin/gosu
#
# gosu nobody true

apt-get purge -y --auto-remove wget
