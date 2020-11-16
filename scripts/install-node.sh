#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep NODE_VERSION $APP_SOURCE_DIR/launchpad.conf)
fi

NODE_VERSION=8.11.1


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

  #statements
printf "\n[-] Installing Node ${NODE_VERSION}...\n\n"

NODE_DIST=node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}

cd /tmp
curl -L http://nodejs.org/dist/v${NODE_VERSION}/${NODE_DIST}.tar.gz \
  -o ${NODE_DIST}.tar.gz
tar xzf ${NODE_DIST}.tar.gz
rm ${NODE_DIST}.tar.gz
rm -rf /opt/nodejs
mv ${NODE_DIST} /opt/nodejs

ln -sf /opt/nodejs/bin/node /usr/bin/node
ln -sf /opt/nodejs/bin/npm /usr/bin/npm
