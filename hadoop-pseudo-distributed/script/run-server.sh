#!/bin/bash

set -e

wget -nc -O raw/hadoop-2.8.0.tar.gz http://apache.claz.org/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz | true

docker build -t hadoop-pseudo .
docker rm -f hadoop | true
docker run -it --name=hadoop -d hadoop-pseudo
