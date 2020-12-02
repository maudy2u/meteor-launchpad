#!/bin/bash
#
# builds a production meteor bundle directory
#
set -e

# Fix permissions warning in Meteor >=1.4.2.1 without breaking
# earlier versions of Meteor with --unsafe-perm or --allow-superuser
# https://github.com/meteor/meteor/issues/7959
# is this needed: https://github.com/meteor/meteor/issues/7852
# Install app deps
cd $APP_SOURCE_DIR

# build the bundle
mkdir -p ${APP_DIST_DIR}
if [ -d "${APP_DIST_DIR}/bundle" ]; then
  rm -rf ${APP_DIST_DIR}/bundle
fi

# change ownership of the app to the node user
# chown -Rh node:node $APP_BUNDLE_DIR
export METEOR_ALLOW_SUPERUSER=true
export METEOR_DISABLE_OPTIMISTIC_CACHING=1
cd $APP_SOURCE_DIR

if [ "$(uname -m)" == "x86_64" ]; then
  printf "\n[-] Building Meteor application (x86_64)...\n\n"
  meteor build --allow-superuser --server-only --directory $APP_DIST_DIR
elif [ "$(uname -m)" == "aarch64" ]; then
  printf "\n[-] Building Meteor application (aarch64)...\n\n"
  meteor build --server-only --directory $APP_DIST_DIR
elif [ "$(uname -p)" == "armv7l" ]; then
  printf "\n[-] Building Meteor application (armv7l)...\n\n"
  meteor build --server-only --directory $APP_DIST_DIR
elif [ "$(uname -m)" == "i386" ]; then
  printf "\n[-] Building Meteor application (i386)...\n\n"
  meteor build --allow-superuser --server-only --directory $APP_DIST_DIR
fi

# statements
# put the entrypoint script in WORKDIR
cp $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/entrypoint.sh

# chown -Rh node:node $APP_BUNDLE_DIR
