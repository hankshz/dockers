#!/bin/bash

set -e

apt-get update
apt-get install -y curl wget tzdata

curl https://omnitruck.chef.io/install.sh | bash -s -- -P chefdk -c stable -v ${CHEFDK_VERSION}
dpkg -i /raw/chef-server-core_${CHEF_SERVER_VERSION}_amd64.deb

mkdir /etc/cron.hourly
