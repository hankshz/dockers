#!/bin/bash

set -e

docker exec -it thrift bash -c "cd /build;./PythonClient.py"
