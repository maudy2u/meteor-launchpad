# FROM node:4
FROM ubuntu:bionic
MAINTAINER Stephen <abordercollie@gmail.com>

RUN groupadd -r node && useradd -m -g node node

# Meteor
ENV METEOR_DISABLE_OPTIMISTIC_CACHING=1

# MongoDB
ENV MONGO_VERSION 4.4.2

# NodeJS
ENV NODE_VERSION 8.11.1

# build directories
ENV APP_SOURCE_DIR /opt/meteor/src
ENV APP_DIST_DIR /opt/meteor/dist
ENV APP_BUNDLE_DIR $APP_DIST_DIR/bundle
ENV BUILD_SCRIPTS_DIR /opt/build_scripts

# PATH revisions
ENV PATH=$APP_DIST_DIR/mongodb/bin:$APP_DIST_DIR/nodejs/bin:$PATH

# Add entrypoint and build scripts
COPY scripts $BUILD_SCRIPTS_DIR
RUN chmod -R 750 $BUILD_SCRIPTS_DIR

# these are from the commandline
# Define all --build-arg options
ONBUILD ARG APT_GET_INSTALL
ONBUILD ENV APT_GET_INSTALL $APT_GET_INSTALL

# needed for newer Mongo and bionic
ONBUILD ARG TZ
ONBUILD ENV TZ $TZ

ONBUILD ARG NODE_VERSION
ONBUILD ENV NODE_VERSION ${NODE_VERSION:-8.11.1}

ONBUILD ARG NPM_TOKEN
ONBUILD ENV NPM_TOKEN $NPM_TOKEN

ONBUILD ARG INSTALL_MONGO
ONBUILD ENV INSTALL_MONGO $INSTALL_MONGO

# Node flags for the Meteor build tool
ONBUILD ARG TOOL_NODE_FLAGS
ONBUILD ENV TOOL_NODE_FLAGS $TOOL_NODE_FLAGS

# optionally custom apt dependencies at app build time
ONBUILD RUN if [ "$APT_GET_INSTALL" ]; then apt-get update && apt-get install -y $APT_GET_INSTALL; fi

# copy the app to the container
ONBUILD COPY . $APP_SOURCE_DIR

# install all dependencies, build app, clean up
ONBUILD RUN cd $APP_SOURCE_DIR && \
  $BUILD_SCRIPTS_DIR/install-deps.sh && \
  $BUILD_SCRIPTS_DIR/install-mongo.sh && \
  $BUILD_SCRIPTS_DIR/install-node.sh && \
  $BUILD_SCRIPTS_DIR/install-meteor.sh && \
  $BUILD_SCRIPTS_DIR/install-meteor-deps.sh && \
  $BUILD_SCRIPTS_DIR/build-meteor.sh && \
  $BUILD_SCRIPTS_DIR/post-build-cleanup.sh
#  $BUILD_SCRIPTS_DIR/post-install-cleanup.sh

# Default values for Meteor environment variables
ENV ROOT_URL http://localhost
ENV MONGO_URL mongodb://localhost:27017/meteor
ENV PORT 3000

EXPOSE 3000

# CMD needs bundle directoy...
WORKDIR $APP_BUNDLE_DIR

VOLUME ["/var/tsx_cmd", "/var/log/tsx_cmd"]

# start the app
# ENTRYPOINT ["./entrypoint.sh"]
# CMD ["node", "main.js"]
