#!/bin/bash

set -e

docker rm -f eth || true
docker run -it --name eth --hostname eth -v $(pwd)/workspace:/workspace -p 8545:8545 -p 80:80 eth
