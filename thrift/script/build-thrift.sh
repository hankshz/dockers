#!/bin/bash

set -e

apt-get update
# Build vanila thrift
apt-get install -y automake bison flex g++ git libboost-all-dev libevent-dev libssl-dev libtool make pkg-config
# Python binding
apt-get install -y python-all python-all-dev python-all-dbg python-pip
pip install six


mkdir /build

tar xvf /raw/thrift-$THRIFT_VERSION.tar.gz -C /build
mv /build/thrift-$THRIFT_VERSION $THRIFT_BUILD
(cd /build/thrift; ./configure)
make -C $THRIFT_BUILD
make -C $THRIFT_BUILD install
