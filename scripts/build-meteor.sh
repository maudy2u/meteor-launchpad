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

# ensure dist direct exists
if [ ! -d "${APP_DIST_DIR}" ]; then
  mkdir -p ${APP_DIST_DIR}
fi

# Handle directory access
if [ -d "${APP_DIST_DIR}/bundle" ]; then
  rm -rf ${APP_DIST_DIR}/bundle
fi

export METEOR_ALLOW_SUPERUSER=true
export METEOR_DISABLE_OPTIMISTIC_CACHING=1

if [ "$(uname -p)" == "armv7l" ]; then
  export ALLOW_INCOMPATIABLE_UPDATE="--allow-incompatible-update"
fi

printf "\n[-] Building Meteor application...\n\n"
cd $APP_SOURCE_DIR
meteor build $ALLOW_INCOMPATIABLE_UPDATE --server-only --directory ${APP_DIST_DIR}

# put the entrypoint script in WORKDIR
cp $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/entrypoint.sh
