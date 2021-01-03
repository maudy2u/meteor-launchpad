#!/bin/bash
set -e

if [ -d "$APP_BUNDLE_DIR/programs/server" ]; then

  # run npm install in bundle
  printf "\n[-] Running npm installing FIBERS in the server bundle...\n\n"

  export PATH=${APP_DIST_DIR}/mongodb/bin:${APP_DIST_DIR}/nodejs/bin:$PATH

  cd $APP_BUNDLE_DIR/programs/server
  printf  "\n[-] METEOR - fix for fibers deploy... \n\n"
  npm uninstall fibers
  npm install fibers

  printf "\n[-] TSX_CMD - npm install...\n\n"
  npm install amdefine ansi-styles chalk escape-string-regexp has-ansi promise source-map strip-ansi type-of ansi-regex asap eachline meteor-promise semver source-map-support supports-color underscore

fi
# get out of the src dir, so we can delete it
cd $APP_BUNDLE_DIR
cp $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/entrypoint.sh
