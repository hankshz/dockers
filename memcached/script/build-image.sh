#!/bin/bash

set -e

wget -nc -O raw/mcrouter-release-36-0.zip https://github.com/facebook/mcrouter/archive/release-36-0.zip || true

docker build -t memcached .
