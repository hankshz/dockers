#!/bin/bash

set -e

docker exec -it logstash rm -rf /data/registry
docker exec -it logstash filebeat -e -c /raw/filebeat.yml
