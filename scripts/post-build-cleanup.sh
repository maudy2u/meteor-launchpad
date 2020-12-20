#!/bin/bash
set -e

if [ -d "$APP_BUNDLE_DIR/programs/server" ]; then

  # run npm install in bundle
  printf "\n[-] Running npm installing FIBERS in the server bundle...\n\n"

  export PATH=${APP_DIST_DIR}/mongodb/bin:${APP_DIST_DIR}/nodejs/bin:$PATH

  cd $APP_BUNDLE_DIR/programs/server
  printf  "\n[-] METEOR - fix for fibers deploy... \n\n"
  npm uninstall fibers
  npm install fibers

  printf "\n[-] TSX_CMD - npm install...\n\n"
  npm install amdefine ansi-styles chalk escape-string-regexp has-ansi promise source-map strip-ansi type-of ansi-regex asap eachline meteor-promise semver source-map-support supports-color underscore

fi
# get out of the src dir, so we can delete it
cd $APP_BUNDLE_DIR

# Clean out docs
rm -rf /usr/share/{doc,doc-base,man,locale,zoneinfo}

# Clean out package management dirs
rm -rf /var/lib/{cache,log}

# remove app source
if [ -z "${DEV_BUILD}" ]; then

  printf  "\n[-] METEOR - src removed... \n\n"

  rm -rf $APP_SOURCE_DIR

  # remove meteor
  rm -rf /usr/local/bin/meteor
  rm -rf /root/.meteor

  # needed for armfh
  rm -rf /root/meteor

  # clean additional files created outside the source tree
  rm -rf /root/{.npm,.cache,.config,.cordova,.local}

  # remove npm
  rm -rf /opt/nodejs/bin/npm
  rm -rf /opt/nodejs/lib/node_modules/npm/

  # remove os dependencies
  apt-get purge -y --auto-remove apt-transport-https build-essential bsdtar bzip2 ca-certificates git python
fi

rm -rf /tmp/*

apt-get -y autoremove
apt-get -y clean
apt-get -y autoclean
rm -rf /var/lib/apt/lists/*
