#!/bin/bash
set -e

# run npm install in bundle
printf "\n[-] Running npm installing FIBERS in the server bundle...\n\n"
cd $APP_BUNDLE_DIR/programs/server
printf  " *******************************"
printf  " METEOR - fix for fibers deploy"
printf  " *******************************"
printf  ""
meteor npm uninstall fibers
meteor npm install fibers

printf "\n[-] Performing final cleanup...\n\n"

# get out of the src dir, so we can delete it
cd $APP_BUNDLE_DIR

# Clean out docs
rm -rf /usr/share/{doc,doc-base,man,locale,zoneinfo}

# Clean out package management dirs
rm -rf /var/lib/{cache,log}

# remove app source
rm -rf $APP_SOURCE_DIR

# remove meteor
rm -rf /usr/local/bin/meteor
rm -rf /root/.meteor
# needed for armfh
rm -rf /root/meteor

# clean additional files created outside the source tree
rm -rf /root/{.npm,.cache,.config,.cordova,.local}
rm -rf /tmp/*

# remove npm
rm -rf /opt/nodejs/bin/npm
rm -rf /opt/nodejs/lib/node_modules/npm/

# remove os dependencies
apt-get purge -y --auto-remove apt-transport-https build-essential bsdtar bzip2 ca-certificates curl git python
apt-get -y autoremove
apt-get -y clean
apt-get -y autoclean
rm -rf /var/lib/apt/lists/*
