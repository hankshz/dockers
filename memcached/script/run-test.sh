#!/bin/bash

set -e

docker exec -it memcached-master /script/test-memcached.py
