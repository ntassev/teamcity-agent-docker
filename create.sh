#!/bin/bash

REPO="ntassev/teamcity-agent"
TAG="3.0"

NAME="teamcity-agent"
TEAMCITY_SERVER=${TEAMCITY_SERVER:-http://teamcity:8111}
TEAMCITY_AGENT_NAME=${TEAMCITY_AGENT_NAME:-$USER}
TEAMCITY_OWN_ADDRESS=${TEAMCITY_OWN_ADDRESS:-$(ip addr | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n1)}

docker create \
 --privileged \
 --name $NAME \
 -e TEAMCITY_SERVER=$TEAMCITY_SERVER \
 -e TEAMCITY_AGENT_NAME=$TEAMCITY_AGENT_NAME \
 -e TEAMCITY_OWN_ADDRESS=$TEAMCITY_OWN_ADDRESS \
 -p 9090:9090 \
 $REPO:$TAG
