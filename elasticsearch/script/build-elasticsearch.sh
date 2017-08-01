#!/bin/bash

set -e

apt-get update
apt-get install -y default-jdk curl
apt-get install -y python3-pip
pip3 install elasticsearch
java -version

mkdir -p /build

tar xvf /raw/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz -C /build
mv /build/elasticsearch-$ELASTICSEARCH_VERSION $ELASTICSEARCH_BUILD

cp /raw/elasticsearch.yml $ELASTICSEARCH_BUILD/config/

tar xvf /raw/kibana-$KIBANA_VERSION-linux-x86_64.tar.gz -C /build
mv /build/kibana-$KIBANA_VERSION-linux-x86_64 $KIBANA_BUILD

cp /raw/kibana.yml $KIBANA_BUILD/config/
