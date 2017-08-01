#!/bin/bash

set -e

# https://www.elastic.co/guide/en/kibana/current/getting-started.html
docker exec -it elasticsearch-master /script/load-data.sh
docker exec -it elasticsearch-master kibana
