#!/bin/bash

set -e

wget -nc -O raw/chef-server-core_12.16.2-1_amd64.deb https://packages.chef.io/files/stable/chef-server/12.16.2/ubuntu/16.04/chef-server-core_12.16.2-1_amd64.deb || true

docker build -t chef .
