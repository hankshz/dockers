#!/bin/bash

# the default node number is 2
N=${1:-2}

docker rm -f elasticsearch-master
i=1
while [ $i -lt $N ]
do
	docker rm -f elasticsearch-slave$i
	i=$(( $i + 1 ))
done
docker network rm elk || true
# https://en.wikipedia.org/wiki/Link-local_address#IPv4
# stupid IP check force to use link local address and it will limit number of hosts to two
docker network create --driver=bridge --subnet 169.254.0.0/16 elk

# 'master' just means the one that exposes the API interface
docker run -itd \
                --net=elk \
                -p 9200:9200 \
                -p 5601:5601 \
                --name elasticsearch-master \
                --hostname elasticsearch-master \
                elasticsearch

i=1
while [ $i -lt $N ]
do
	docker run -itd \
	                --net=elk \
	                --name elasticsearch-slave$i \
	                --hostname elasticsearch-slave$i \
	                elasticsearch
	i=$(( $i + 1 ))
done

# Take a while for logstash to start
sleep 20
