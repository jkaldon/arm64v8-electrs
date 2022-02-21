#!/bin/sh
set -ex
DOCKER_TAG=v0.9.5-1

docker build --progress plain -t "jkaldon/arm64v8-electrs:${DOCKER_TAG}" .
docker push "jkaldon/arm64v8-electrs:${DOCKER_TAG}"
