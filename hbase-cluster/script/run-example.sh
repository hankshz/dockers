#!/bin/bash

set -e

docker exec hbase-master stop-hbase.sh
docker exec hbase-master stop-yarn.sh
docker exec hbase-master stop-dfs.sh
docker exec hbase-master rm -rf /usr/local/zookeeper
docker exec hbase-slave1 rm -rf /usr/local/zookeeper

docker exec hbase-master start-dfs.sh
docker exec hbase-master start-yarn.sh
sleep 20
docker exec hbase-master start-hbase.sh
sleep 20
docker exec hbase-master hbase shell /raw/sample.txt
docker exec hbase-master stop-hbase.sh
docker exec hbase-master stop-yarn.sh
docker exec hbase-master stop-dfs.sh
