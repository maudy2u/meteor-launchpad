#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep NODE_VERSION $APP_SOURCE_DIR/launchpad.conf)
else
  export NODE_VERSION=8.11.1
fi

if [ "$(uname)" == "Darwin" ]; then
  NODE_OS=darwin
elif [ "$(uname)" == "Linux" ]; then
  NODE_OS=linux
  NODE_ARCH=x64
fi

if [ "$(uname -m)" == "x86_64" ]; then
  NODE_ARCH=x64
elif [ "$(uname -m)" == "armv7l" ] || [ "$(uname -p)" == "armv7l" ]; then
  NODE_ARCH=armv7l
elif [ "$(uname -m)" == "aarch64" ] || [ "$(uname -m)" == "arm64" ]; then
  NODE_ARCH=arm64
elif [ "$(uname -m)" == "i386" ]; then
  NODE_ARCH=i386
fi

NODE_DIST=node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}

cd ${APP_DIST_DIR}
mkdir -p ./nodejs
printf "\n[-] Nodejs - Download and extract ${NODE_VERSION}...\n\n"
curl -L http://nodejs.org/dist/v${NODE_VERSION}/${NODE_DIST}.tar.gz \
  -o nodejs.tar.gz
# tar xzf ${NODE_DIST}.tar.gz
tar -xf nodejs.tar.gz -C ./nodejs --strip-components=1
rm ${APP_DIST_DIR}/nodejs.tar.gz

# not needed as environment is updated in the Dockerfile
#ln -sf /opt/nodejs/bin/node /usr/bin/node
#ln -sf /opt/nodejs/bin/npm /usr/bin/npm

# https://github.com/npm/npm/pull/13257
# cd $(npm root -g)/npm \
# && npm install fs-extra \
# && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js
