#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep MONGO_PARAM $APP_SOURCE_DIR/launchpad.conf)
fi

# remove any mongo params for armv7
if [ "$(uname -m)" == "armv7l" ]; then
    MONGO_PARAM=''
fi

# try to start local MongoDB if no external MONGO_URL was set
if [[ "${MONGO_URL}" == *"127.0.0.1"* ]] || [[ "${MONGO_URL}" == *"localhost"* ]]; then
  #if [ -x "$(command -v mongod)" ]; then
  if hash mongod 2>/dev/null; then
    printf "\n[-] *******************************\n\n"
    printf "\n[-] Starting mongod...\n\n"
    printf "\n[-] *******************************\n\n"
    #exec gosu mongodb mongod --storageEngine=wiredTiger > /dev/null 2>&1 &
    mkdir -p $APP_DIST_DIR/data/db
    mkdir -p $APP_DIST_DIR/log/mongod
    mongod $MONGO_PARAM --dbpath $APP_DIST_DIR/data/db --logpath $APP_DIST_DIR/log/mongod/mongod.log --journal &
  else
    printf "\n[!!!] ERROR: Mongo not installed inside the container.n\n"
    printf "\n[!!!] Rebuild with INSTALL_MONGO=true in your launchpad.conf or supply a MONGO_URL environment variable.n\n"
    exit 1
  fi
fi

# Set a delay to wait to start the Node process
if [[ ! -z $STARTUP_DELAY ]]; then
  printf "\n[-] Delaying startup for $STARTUP_DELAY seconds...n\n"
  sleep $STARTUP_DELAY
fi

if [ "${1:0:1}" = '-' ]; then
	set -- node "$@"
fi

# # allow the container to be started with `--user`
# if [ "$1" = "node" -a "$(id -u)" = "0" ]; then
# 	exec gosu node "$BASH_SOURCE" "$@"
# fi

# Start app
cd $APP_BUNDLE_DIR

echo "=> Starting app on port $PORT..."
exec "$@"
