#!/bin/bash

set -e

wget -nc -O raw/hadoop-2.8.0.tar.gz http://apache.claz.org/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz || true
wget -nc -O raw/hbase-1.2.6.tar.gz http://apache.claz.org/hbase/stable/hbase-1.2.6-bin.tar.gz || true

docker build -t hbase-cluster .
