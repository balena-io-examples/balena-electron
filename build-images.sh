#!/bin/bash

#
# Call this script to build your multi-architecture images using docker buildx. This will upload the manifest of all the multi-arch builds under one tag name.
# Usage: ./build-images.sh <repo> <image_name> <tag>
#

set -e

DOCKER_REPO=${1:-"balena-io-examples"}
IMAGE_NAME=${2:-"balena-electron"}
TAG=${3:-"1.0.0"}

echo "Building all $DOCKER_REPO/$IMAGE_NAME:$TAG"

function build_and_push_image () {
  local BALENA_ARCH=$1
  local PLATFORM=$2

  TAG=$DOCKER_REPO/$IMAGE_NAME:$BALENA_ARCH-$TAG

  echo "Building for $BALENA_ARCH, platform $PLATFORM, pushing to $TAG"
  
  docker buildx build . --pull \
      --build-arg BALENA_ARCH=$BALENA_ARCH \
      --platform $PLATFORM \
      --file Dockerfile.template \
      --tag $TAG --load

  echo "Pushing..."
  docker push $TAG
}

function create_and_push_manifest() {
  docker manifest create $DOCKER_REPO/$IMAGE_NAME:latest \
  --amend $DOCKER_REPO/$IMAGE_NAME:aarch64-$TAG \
  --amend $DOCKER_REPO/$IMAGE_NAME:armv7hf-$TAG \
  --amend $DOCKER_REPO/$IMAGE_NAME:rpi-$TAG \
  --amend $DOCKER_REPO/$IMAGE_NAME:amd64-$TAG 

  docker manifest push --purge $DOCKER_REPO/$IMAGE_NAME:latest
}

build_and_push_image "aarch64" "linux/arm64" 
build_and_push_image "amd64" "linux/amd64"
build_and_push_image "armv7hf" "linux/arm/v7" 
build_and_push_image "rpi" "linux/arm/v6"

create_and_push_manifest
