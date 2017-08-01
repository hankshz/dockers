#!/bin/bash

set -e

wget -nc -O raw/hbase-1.2.6.tar.gz http://apache.claz.org/hbase/stable/hbase-1.2.6-bin.tar.gz | true

docker build -t hbase-standalone .
docker rm -f hbase | true
docker run -it --name=hbase -d hbase-standalone bash
