#!/bin/bash

set -e

source $(dirname "${BASH_SOURCE[0]}")/common.sh

i=1
while [ $i -lt $N ]
do
    docker rm -f balancer$i || true
	i=$(( $i + 1 ))
done

i=1
while [ $i -lt $N ]
do
    docker rm -f web$i || true
	i=$(( $i + 1 ))
done

docker rm -f chef-workstation || true
docker rm -f chef-server || true
docker network rm chef || true

docker network create --driver=bridge chef

docker run -dit --net=chef --name chef-server --hostname chef-server chef
docker exec -it chef-server bash /script/reconfigure-chef-server.sh

i=1
while [ $i -lt $N ]
do
	docker run -dit --net=chef --name balancer$i --hostname balancer$i rastasheep/ubuntu-sshd:14.04
    # Chef client requires sudo that the upstream image is missing
    docker exec -it balancer$i apt-get install sudo
	i=$(( $i + 1 ))
done

i=1
while [ $i -lt $N ]
do
	docker run -dit --net=chef --name web$i --hostname web$i rastasheep/ubuntu-sshd:14.04
    # Chef client requires sudo that the upstream image is missing
    docker exec -it web$i apt-get install sudo
	i=$(( $i + 1 ))
done

docker run -dit --net=chef --name chef-workstation --hostname chef-workstation -v $(pwd)/chef-repo:/chef-repo chef
docker exec -it chef-workstation bash /script/reconfigure-chef-workstation.sh
docker exec -it chef-workstation bash

