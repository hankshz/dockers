#!/bin/bash

set -e

apt-get update
apt-get install -y default-jdk
java -version

mkdir -p /build

tar xvf /raw/logstash-$LOGSTASH_VERSION.tar.gz -C /build
mv /build/logstash-$LOGSTASH_VERSION $LOGSTASH_BUILD

dpkg -i /raw/filebeat-$FILEBEAT_VERSION-amd64.deb
