#!/bin/bash

set -e

docker exec -it chef-workstation bash /script/reconfigure-chef-nodes.sh
