#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep TOOL_NODE_FLAGS $APP_SOURCE_DIR/launchpad.conf)
  source <(grep METEOR_ADD $APP_SOURCE_DIR/launchpad.conf)
  source <(grep METEOR_NPM_SAVE_DEV $APP_SOURCE_DIR/launchpad.conf)
  source <(grep METEOR_NPM_SAVE $APP_SOURCE_DIR/launchpad.conf)
  source <(grep METEOR_ARM64 $APP_SOURCE_DIR/launchpad.conf)
  source <(grep METEOR_ARM $APP_SOURCE_DIR/launchpad.conf)
  source <(grep METEOR_x86_64 $APP_SOURCE_DIR/launchpad.conf)
fi

# set up npm auth token if one is provided
if [[ "$NPM_TOKEN" ]]; then
  echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" >> ~/.npmrc
fi

# Fix permissions warning in Meteor >=1.4.2.1 without breaking
# earlier versions of Meteor with --unsafe-perm or --allow-superuser
# https://github.com/meteor/meteor/issues/7959
export METEOR_ALLOW_SUPERUSER=true

# is this needed: https://github.com/meteor/meteor/issues/7852
# Install app deps
cd $APP_SOURCE_DIR

if [ "$(uname -m)" == "x86_64" ] && [ "$METEOR_x86_64" ]; then
  printf "\n[-] Running meteor add $METEOR_x86_64 installs in $APP_SOURCE_DIR...\n\n"
  meteor add $METEOR_x86_64
elif [ "$(uname -m)" == "aarch64" ] && [ "$METEOR_ARM64" ]; then
  printf "\n[-] Running meteor add $METEOR_ARM64 installs in $APP_SOURCE_DIR...\n\n"
  meteor add $METEOR_ARM64
elif [ "$(uname -p)" == "armv7l" ] && [ "$METEOR_ARM" ]; then
  printf "\n[-] Running meteor add $METEOR_ARM installs in $APP_SOURCE_DIR...\n\n"
  meteor add $METEOR_ARM
elif [ "$(uname -m)" == "i386" ] && [ "$METEOR_x86_64" ]; then
  printf "\n[-] Running meteor add $METEOR_x86_64 installs in $APP_SOURCE_DIR...\n\n"
  meteor add $METEOR_x86_64
fi

#meteor remove standard-minifier-css
if [ "$METEOR_ADD" ]; then
  printf "\n[-] Running meteor add install in $APP_SOURCE_DIR...\n\n"
  meteor add $METEOR_ADD
fi
if [ "$METEOR_NPM_SAVE_DEV" ]; then
  printf "\n[-] Running meteor npm install --save-dev in $APP_SOURCE_DIR...\n\n"
  meteor npm install --save-dev $METEOR_NPM_SAVE_DEV
fi
if [ "$METEOR_NPM_SAVE" ]; then
  printf "\n[-] Running meteor npm install --save in $APP_SOURCE_DIR...\n\n"
  meteor npm install --save $METEOR_NPM_SAVE
fi
printf "\n[-] Running meteor npm install in app directory...\n\n"
meteor npm install
