#!/usr/bin/env bash

# The following docker will be generated:
#  - flow.ci.backend: it includes api and control center
#  - flow.ci.agent:

# How to run flow.ci
# - backend: 'docker-compose up'
# - agent: docker run --network=host -e FLOW_ZOOKEEPER_HOST=127.0.0.1:2181 -e FLOW_AGENT_ZONE=default -e FLOW_AGENT_NAME={agent name} flow.ci.agent
FLOW_PLATFORM_PATH=../flow-platform
FLOW_WEB_PATH=../flow-web

cd $FLOW_PLATFORM_PATH
# mvn build artifact of each components
mvn clean install -DskipTests=true

cp ../docker/Dockerfile-backend .
# build docker image for flow.ci backend
docker build -t flow.ci.backend -f ./Dockerfile-backend .

# build docker compose service for flow.ci backend
docker-compose rm -f
docker-compose build


cp ../docker/Dockerfile-agent .
# build docker image for flow.ci agent
docker build -t flow.ci.agent -f ./Dockerfile-agent .

# build web
cd $FLOW_WEB_PATH
FLOW_WEB_API=http://localhost:8080/flow-api   npm run  build

cp ../flow-web/Dockerfile-web .
docker build -t flow.web -f ./Dockerfile-web .
# docker build -t will/tomcat-git -f ./Dockerfile-git .