#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  #source <(grep MONGO_PARAM $APP_SOURCE_DIR/launchpad.conf)
  echo ''
fi

cd $APP_SOURCE_DIR
$BUILD_SCRIPTS_DIR/build-meteor.sh
$BUILD_SCRIPTS_DIR/post-build-cleanup.sh

cd $APP_BUNDLE_DIR
