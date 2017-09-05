# Using the TeamCity Agent container

Create the container:

    TEAMCITY_SERVER=http://your_teamcity_server ./create.sh
    
Put the init-script in place:

    sudo cp init-scripts/upstart/teamcity-agent.conf /etc/init/
    
or

    sudo cp init-scripts/systemd/teamcity-agent.service /lib/systemd/system/
    
Start the container:

    sudo service teamcity-agent start


Teamcity build agent
========================

This is a teamcity build agent docker image, it uses docker in docker from https://github.com/jpetazzo/dind to allow you to start docker images inside of it :)
When starting the image as container you must set the TEAMCITY_SERVER environment variable to point to the teamcity server e.g.
```
docker run -e TEAMCITY_SERVER=http://localhost:8111
```

Optionally you can specify your ownaddress using the `TEAMCITY_OWN_ADDRESS` variable.

Linking example
--------
```
docker run -d --name=teamcity-agent-1 --link teamcity:teamcity --privileged -e TEAMCITY_SERVER=http://teamcity:8111 sjoerdmulder/teamcity-agent:latest
```

## What is inside

- node 4.2.6, npm 3.5.0
