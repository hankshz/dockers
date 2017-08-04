#!/bin/bash

set -e

apt-get update
apt-get install -y default-jdk python
java -version

cp /raw/dumb-init_${DUMB_INIT_VERSION}_amd64 /sbin/dumb-init
chmod +x /sbin/dumb-init

mkdir -p /build

tar xvf /raw/apache-cassandra-$CASSANDRA_VERSION.tar.gz -C /build
mv /build/apache-cassandra-$CASSANDRA_VERSION $CASSANDRA_BUILD

mkdir -p $CASSANDRA_CONF
mkdir -p $CASSANDRA_DATA/data
cp /raw/logback.xml $CASSANDRA_CONF/logback.xml
cp /raw/cassandra.yaml $CASSANDRA_CONF/cassandra.yaml
cp $CASSANDRA_HOME/conf/jvm.options $CASSANDRA_CONF/jvm.options
cp $CASSANDRA_HOME/conf/cassandra-env.sh $CASSANDRA_CONF/cassandra-env.sh
