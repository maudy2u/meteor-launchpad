#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep TOOL_NODE_FLAGS $APP_SOURCE_DIR/launchpad.conf)
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
printf "\n[-] Running npm install in app directory...\n\n"
cd $APP_SOURCE_DIR

#meteor remove standard-minifier-css
meteor add ostrio:files semantic:ui juliancwirko:postcss less jquery react-meteor-data froatsnook:sleep package-stats-opt-out session vsivsi:job-collection dburles:collection-helpers ostrio:logger ostrio:loggerconsole ostrio:loggerfile ostrio:meteor-root ostrio:loggermongo
meteor npm install --save-dev babel-plugin-transform-class-properties postcss postcss-load-config autoprefixer
meteor npm install --save @babel/runtime xml-js react-simple-range react-datetime-bootstrap react-timekeeper react react-dom shelljs bootstrap@^3.3 semantic-ui-react formsy-semantic-ui-react formsy-react xregexp postcss-easy-import postcss-nested postcss-simple-vars rucksack-css
meteor npm install

# build the bundle
printf "\n[-] Building Meteor application...\n\n"
mkdir -p $APP_DIST_DIR
#
meteor build --server-only --directory $APP_DIST_DIR

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/entrypoint.sh

# change ownership of the app to the node user
chown -Rh node:node $APP_BUNDLE_DIR
