#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep INSTALL_MONGO $APP_SOURCE_DIR/launchpad.conf)
fi

if [ "$INSTALL_MONGO" = true ]; then
  # server: 'https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/4.4/multiverse/binary-amd64/mongodb-org-server_4.4.1_amd64.deb'
  # shell:


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
# https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1804-4.4.1.tgz
# https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-4.4.1.tgz
# https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-${MONGO_VERSION}.tgz
# https://fastdl.mongodb.org/${MONGO_DIR}/mongodb-${MONGO_OS}-${MONGO_VERSION}.tgz

# https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.2.1.tgz
# https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.2.1.tgz
# https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-arm64-100.2.1.tgz
# https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.2.1.zip
# https://fastdl.mongodb.org/tools/db/mongodb-database-tools-${MONGO_OS}-100.2.1.zip
# https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.2.1.tgz


    #statements
  printf "\n[-] Installing MongoDB ${MONGO_DIST}...\n\n"

  # https://docs.mongodb.com/master/tutorial/install-mongodb-on-ubuntu/
  #  apt-get install -y --no-install-recommends gnupg wget curl tzdata openssl
  #  apt-get install -y gnupg wget curl tzdata openssl
  #  apt-get install -y gnupg tzdata openssl
  apt-get install -y openssl liblzma5
  # apt-get install -y libcurl4 openssl liblzma5

  # export MONGO_ARCH=amd64
  # export MONGO_VERSION=4.4.1
  # export MONGO_MAJOR=4.4

  # MONGODB
  export MONGO_PARAMS="-C ./mongodb  --strip-components=1"
  cd ${APP_DIST_DIR}
  printf "\n[-] Mongodb - Download and extract ${MONGO_DIST}.tgz...\n\n"
  mkdir -p ./mongodb/bin
  curl -sL https://fastdl.mongodb.org/${MONGO_DIR}/${MONGO_DIST}.tgz \
    -o mongodb.tgz
  tar -xf mongodb.tgz ${MONGO_PARAMS}
  rm ${APP_DIST_DIR}/mongodb.tgz

  # TOOLS
  printf "\n[-] Installing MongoDB Tools ${MONGO_TOOLS}...\n\n"
  # # printf "\n[-] https://fastdl.mongodb.org/tools/db/${MONGO_TOOLS}\n\n"
  # # printf "\n[-] https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.2.1.tgz\n\n"
  curl -sL https://fastdl.mongodb.org/tools/db/${MONGO_TOOLS} \
   -o tools.tgz
   tar -xf tools.tgz ${MONGO_PARAMS}
   rm ${APP_DIST_DIR}/tools.tgz

  mkdir -p /var/lib/mongodb
  # chown -R mongodb:mongodb /var/lib/mongodb
fi
