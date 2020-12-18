#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep INSTALL_MONGO $APP_SOURCE_DIR/launchpad.conf)
  source <(grep MONGO_VERSION $APP_SOURCE_DIR/launchpad.conf)
fi

if [ "$INSTALL_MONGO" = true ]; then
  # server: 'https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/4.4/multiverse/binary-amd64/mongodb-org-server_4.4.1_amd64.deb'
  if [ "$(uname -m)" == "x86_64" ]; then
    MONGO_ARCH=x86_64
  elif [ "$(uname -m)" == "aarch64" ] || [ "$(uname -m)" == "arm64" ]; then
    MONGO_ARCH=aarch64
  elif [ "$(uname -p)" == "armv7l" ] || [ "$(uname -m)" == "armv7l" ]; then
    MONGO_ARCH=armv7l
  elif [ "$(uname -m)" == "i386" ]; then
    MONGO_ARCH=i386
  fi

  if [ "$(uname -s)" == "Darwin" ] && [ "$(uname -m)" == "x86_64" ]; then
    MONGO_DIR=osx
    MONGO_OS=macos-x86_64
    TOOLS_OS=macos-x86_64
    TOOLS_EXT=zip
  elif [ "$(uname -s)" == "Linux" ] && [ "$(uname -m)" == "x86_64" ]; then
    MONGO_DIR=linux
    MONGO_OS=linux-x86_64-ubuntu1804
    TOOLS_OS=ubuntu1804-x86_64
    TOOLS_EXT=tgz
  elif [ "$(uname -s)" == "Linux" ] && [ "$(uname -m)" == "aarch64" ]; then
    MONGO_DIR=linux
    MONGO_OS=linux-aarch64-ubuntu1804
    TOOLS_OS=ubuntu1804-arm64
    TOOLS_EXT=tgz
  fi
  # server

  MONGO_DIST=mongodb-${MONGO_OS}-${MONGO_VERSION}
  TOOLS=mongodb-database-tools-${TOOLS_OS}-100.2.1
  MONGO_TOOLS=${TOOLS}.${TOOLS_EXT}

  #statements
  printf "\n[-] Installing MongoDB ${MONGO_DIST}...\n\n"

  # https://docs.mongodb.com/master/tutorial/install-mongodb-on-ubuntu/
  apt-get install -y openssl liblzma5

  # MONGODB
  cd ${APP_DIST_DIR}
  mkdir -p ./mongodb/bin
  if [ "$(uname -m)" == "armv7l" ] || [ "$(uname -p)" == "armv7l" ]; then
    cd ${APP_DIST_DIR}/mongodb/bin
    export MONGO_PARAMS="-C .  --strip-components=1"
    printf "\n[-] MONGO precompiled release from GitHub - mongoDB_armv7.tar...\n\n"
    curl -sL https://github.com/maudy2u/tsx_cmd/releases/download/armv7_mongo/mongoDB_armv7.tar \
      -o mongodb.tgz
  else
    export MONGO_PARAMS="-C ./mongodb  --strip-components=1"
    printf "\n[-] Mongodb - Download and extract ${MONGO_DIST}.tgz...\n\n"
    curl -sL https://fastdl.mongodb.org/${MONGO_DIR}/${MONGO_DIST}.tgz \
      -o mongodb.tgz
  fi
  tar -xf mongodb.tgz ${MONGO_PARAMS}
  rm ./mongodb.tgz

  # TOOLS
  if [ "$(uname -m)" == "armv7l" ] || [ "$(uname -p)" == "armv7l" ]; then
    printf "\n[-] No MongoDB Tools for armv7l...\n\n"
  else
    printf "\n[-] Installing MongoDB Tools ${MONGO_TOOLS}...\n\n"
    curl -sL https://fastdl.mongodb.org/tools/db/${MONGO_TOOLS} \
     -o tools.tgz
     tar -xf tools.tgz ${MONGO_PARAMS}
     rm ${APP_DIST_DIR}/tools.tgz
   fi

  mkdir -p /var/lib/mongodb

# end MONGO IF INSTALL
fi
