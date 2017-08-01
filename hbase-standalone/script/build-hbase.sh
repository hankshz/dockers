#!/bin/bash

set -e

apt-get update
apt-get install -y default-jdk
java -version

mkdir /build

tar xvf /raw/hbase-$HBASE_VERSION.tar.gz -C /build
mv /build/hbase-$HBASE_VERSION $HBASE_BUILD
hbase version
