#!/bin/bash
set -e

printf  "\n[-] METEOR - src removed... \n\n"

rm -rf $APP_SOURCE_DIR

# remove app source
if [ ! -z "${DEV_BUILD}" ]; then

  printf  "\n[-] METEOR - removed... \n\n"

  # remove meteor
  rm -rf /usr/local/bin/meteor
  rm -rf /root/.meteor

  # needed for armfh
  rm -rf /root/meteor

  # clean additional files created outside the source tree
  rm -rf /root/{.npm,.cache,.config,.cordova,.local}

  # remove npm
  # rm -rf /opt/nodejs/bin/npm
  # rm -rf /opt/nodejs/lib/node_modules/npm/

  # remove os dependencies
  apt-get purge -y --auto-remove apt-transport-https build-essential bsdtar bzip2 ca-certificates git python
fi

printf "\n[-] Performing post install cleanup...\n\n"
# Clean out docs
rm -rf /usr/share/{doc,doc-base,man,locale,zoneinfo}

# Clean out package management dirs
rm -rf /var/lib/{cache,log}

rm -rf /tmp/*

apt-get -y autoremove
apt-get -y clean
apt-get -y autoclean
rm -rf /var/lib/apt/lists/*

# Clean out docs
rm -rf /usr/share/{doc,doc-base,man,locale,zoneinfo}

# Clean out package management dirs
rm -rf /var/lib/{cache,log}

rm -rf /tmp/*

# remove os dependencies
apt-get -y autoremove
rm -rf /var/lib/apt/lists/*
