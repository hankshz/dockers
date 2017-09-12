#!/bin/bash

set -e

docker rm -f eth || true
docker run -it --name eth --hostname eth -v $(pwd)/workspace:/workspace eth bash
