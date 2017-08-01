#!/bin/bash

set -e

docker build -t thrift .
docker rm -f thrift | true
docker run --name=thrift -d thrift
