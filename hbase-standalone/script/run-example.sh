#!/bin/bash

set -e

docker exec hbase start-hbase.sh
docker exec hbase hbase shell /raw/sample.txt
docker exec hbase stop-hbase.sh
