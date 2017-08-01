#!/bin/bash

set -e

docker exec -it elasticsearch-master /script/run-search.py
