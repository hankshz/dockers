#!/bin/bash

set -e

apt-get update
apt-get install -y default-jdk
java -version

mkdir -p /build

tar xvf /raw/hbase-$HBASE_VERSION.tar.gz -C /build
mv /build/hbase-$HBASE_VERSION $HBASE_BUILD
sed -i 's@# export JAVA_HOME=/usr/java/jdk1.6.0/@export JAVA_HOME='"$JAVA_HOME"'@g' $HBASE_BUILD/conf/hbase-env.sh
cp /raw/hbase/hbase-site.xml $HBASE_BUILD/conf/hbase-site.xml
cp /raw/hbase/backup-masters $HBASE_BUILD/conf/backup-masters
cp /raw/hbase/regionservers $HBASE_BUILD/conf/regionservers
hbase version
