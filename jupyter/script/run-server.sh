#!/bin/bash

set -e

wget -nc -O raw/Anaconda3-4.4.0-Linux-x86_64.sh https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh || true

docker build -t jupyter .
docker rm -f jupyter || true
docker run -dit --init --name=jupyter -v $(pwd)/workspace:/workspace jupyter
IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jupyter)
sleep 5
x-www-browser ${IP}:8888
