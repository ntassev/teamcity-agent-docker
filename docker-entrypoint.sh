#!/bin/bash

if [ -z "$TEAMCITY_SERVER" ]; then
    echo "TEAMCITY_SERVER variable not set, launch with -e TEAMCITY_SERVER=http://mybuildserver"
    exit 1
fi

if [ -z "$TEAMCITY_AGENT_NAME" ]; then
    echo "TEAMCITY_AGENT_NAME variable not set, launch with -e TEAMCITY_AGENT_NAME=some-name"
    exit 1
fi

if [ -z "${TEAMCITY_OWN_ADDRESS}" ]; then
    echo "TEAMCITY_OWN_ADDRESS variable not set, launch with -e TEAMCITY_OWN_ADDRESS=external_ip_accessible_to_the_teamcity_server"
    exit 1
fi


if [ ! -d "$AGENT_DIR/bin" ]; then
    echo "$AGENT_DIR doesn't exist pulling build-agent from server $TEAMCITY_SERVER";
    let waiting=0
    until curl -s -f -I -X GET $TEAMCITY_SERVER/update/buildAgent.zip; do
        let waiting+=3
        sleep 3
        if [ $waiting -eq 120 ]; then
            echo "Teamcity server did not respond within 120 seconds"...
            exit 42
        fi
    done
    wget $TEAMCITY_SERVER/update/buildAgent.zip && unzip -d $AGENT_DIR buildAgent.zip && rm buildAgent.zip
    chmod +x $AGENT_DIR/bin/agent.sh
    echo "serverUrl=${TEAMCITY_SERVER}" > $AGENT_DIR/conf/buildAgent.properties
    echo "ownAddress=${TEAMCITY_OWN_ADDRESS}" >> $AGENT_DIR/conf/buildAgent.properties
    echo "name=${TEAMCITY_AGENT_NAME}" >> $AGENT_DIR/conf/buildAgent.properties
fi

echo "Starting buildagent..."
chown -R teamcity:teamcity /opt/buildAgent

wrapdocker gosu teamcity /opt/buildAgent/bin/agent.sh run
