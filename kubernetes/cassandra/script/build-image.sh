#!/bin/bash

set -e

wget -nc -O raw/apache-cassandra-3.11.0.tar.gz http://apache.claz.org/cassandra/3.11.0/apache-cassandra-3.11.0-bin.tar.gz || true
wget -nc -O raw/dumb-init_1.2.0_amd64 https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 || true

docker build -t local-cassandra .
