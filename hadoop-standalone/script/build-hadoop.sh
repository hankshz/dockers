#!/bin/bash

set -e

apt-get update
apt-get install -y default-jdk
java -version

mkdir /build

tar xvf /raw/hadoop-$HADOOP_VERSION.tar.gz -C /build
mv /build/hadoop-$HADOOP_VERSION $HADOOP_BUILD
$HADOOP_BUILD/bin/hadoop version
