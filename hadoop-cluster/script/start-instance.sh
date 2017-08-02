#!/bin/bash

# the default node number is 3
N=${1:-3}

docker rm -f hadoop-master
i=1
while [ $i -lt $N ]
do
	docker rm -f hadoop-slave$i
	i=$(( $i + 1 ))
done
docker network rm hadoop || true
docker network create --driver=bridge hadoop

# https://hadoop.apache.org/docs/r0.23.11/hadoop-project-dist/hadoop-common/ClusterSetup.html#Web_Interfaces
docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                hadoop-cluster

i=1
while [ $i -lt $N ]
do
	docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                hadoop-cluster
	i=$(( $i + 1 ))
done
