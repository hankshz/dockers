#!/bin/bash

set -e

wget -nc -O raw/elasticsearch-5.5.1.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.1.tar.gz | true
wget -nc -O raw/kibana-5.5.1-linux-x86_64.tar.gz https://artifacts.elastic.co/downloads/kibana/kibana-5.5.1-linux-x86_64.tar.gz | true

docker build -t elasticsearch .
