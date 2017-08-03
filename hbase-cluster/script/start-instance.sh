#!/bin/bash

# the default node number is 2
N=${1:-2}

docker rm -f hbase-master
i=1
while [ $i -lt $N ]
do
	docker rm -f hbase-slave$i
	i=$(( $i + 1 ))
done
docker network rm hbase || true
docker network create --driver=bridge hbase

# https://hadoop.apache.org/docs/r0.23.11/hadoop-project-dist/hadoop-common/ClusterSetup.html#Web_Interfaces
docker run -itd \
                --net=hbase \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hbase-master \
                --hostname hbase-master \
                hbase-cluster

i=1
while [ $i -lt $N ]
do
	docker run -itd \
	                --net=hbase \
	                --name hbase-slave$i \
	                --hostname hbase-slave$i \
	                hbase-cluster
	i=$(( $i + 1 ))
done
