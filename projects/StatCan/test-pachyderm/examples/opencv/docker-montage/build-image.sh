#!/usr/bin/env bash

set -e

test -z "$1" && echo Need version number && exit 1

IMAGE="pachyderm-demo-montage:$1"

docker build . --tag $IMAGE > stdout.docker.build 2> stderr.docker.build

# docker tag  SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker   tag  $IMAGE             paradisepilot/$IMAGE
docker   push                    paradisepilot/$IMAGE

