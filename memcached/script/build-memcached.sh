#!/bin/bash

set -e

apt-get update
apt-get install -y memcached python3-pip sudo unzip
pip3 install pymemcache

mkdir /build

unzip /raw/mcrouter-release-$MCROUTER_VERSION.zip -d /build
mv /build/mcrouter-release-$MCROUTER_VERSION $MCROUTER_BUILD
$MCROUTER_BUILD/mcrouter/scripts/install_ubuntu_16.04.sh $MCROUTER_BUILD -j4
mcrouter --version
