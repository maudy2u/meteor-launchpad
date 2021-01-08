#!/bin/bash

set -e

if [ $# -lt 2 ]
  then
    echo ""
    echo " *******************************"
    echo ": You need to provide two parameters to build"
    echo ": Example usage:"
    echo ": ./deploy.sh maudy2u/meteor-launchpad v1.0.0"
    echo " *******************************"
    echo ""
    exit 1
fi

# maudy2u/meteor-launchpad
IMAGE_NAME=$1
# v1.0.0
VERSION=$2

printf "\n[-] Create Buildx context...\n\n"
docker buildx create --name myBuilder_$VERSION
docker buildx use myBuilder_$VERSION

printf "\n[-] Create Buildx context...\n\n"
docker buildx build --no-cache --platform linux/amd64,linux/arm64,linux/arm/v7 -t $IMAGE_NAME:latest -t $IMAGE_NAME:$VERSION --push .

printf "\n[-] Remove Buildx context...\n\n"
docker buildx rm myBuilder_$VERSION
