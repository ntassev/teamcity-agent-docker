#!/bin/sh

REPO="ntassev/teamcity-agent-docker"
TAG="3.0"

docker build -t $REPO:$TAG $(dirname $0) || exit $?
echo $REPO:$TAG image is ready.
