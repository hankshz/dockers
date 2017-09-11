#!/bin/bash

set -e

apt-get update
apt-get install -y curl

# Require 8+ nodejs
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
npm install -g ethereumjs-testrpc truffle
