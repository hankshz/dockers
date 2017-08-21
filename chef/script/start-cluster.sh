#!/bin/bash

set -e

docker rm -f node1 || true
docker rm -f node2 || true
docker rm -f chef-workstation || true
docker rm -f chef-server || true
docker network rm chef || true

docker network create --driver=bridge chef

docker run -dit --net=chef --name chef-server --hostname chef-server chef
docker exec -it chef-server bash /script/reconfigure-chef-server.sh

docker run -dit --net=chef --name node1 --hostname node1 rastasheep/ubuntu-sshd:16.04
# Chef client requires sudo that the upstream image is missing
docker exec -it node1 apt-get install sudo
docker run -dit --net=chef --name node2 --hostname node2 rastasheep/ubuntu-sshd:14.04
# Chef client requires sudo that the upstream image is missing
docker exec -it node2 apt-get install sudo

docker run -dit --net=chef --name chef-workstation --hostname chef-workstation -v $(pwd)/chef-repo:/chef-repo chef
docker exec -it chef-workstation bash /script/reconfigure-chef-workstation.sh
docker exec -it chef-workstation bash

