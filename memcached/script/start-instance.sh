#!/bin/bash

# the default node number is 3
N=${1:-4}

docker rm -f memcached-master
i=1
while [ $i -lt $N ]
do
	docker rm -f memcached-slave$i
	i=$(( $i + 1 ))
done
docker network rm memcached || true

docker network create --driver=bridge memcached

# Master will run a mcrouter instead of a memcached
docker run -itd --net=memcached --name memcached-master --hostname memcached-master memcached mcrouter -f /raw/mcrouter.conf -p 11211

i=1
while [ $i -lt $N ]
do
	docker run -itd --net=memcached --name memcached-slave$i --hostname memcached-slave$i memcached
	i=$(( $i + 1 ))
done
