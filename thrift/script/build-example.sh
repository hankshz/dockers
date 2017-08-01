#!/bin/bash

set -e

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
thrift -version
cp /raw/*.thrift /build
cp /raw/*.py /build
(cd /build; thrift -r --gen py tutorial.thrift)
