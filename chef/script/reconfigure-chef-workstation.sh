#!/bin/bash

set -e

wget -O /tmp/knife_admin_key.tar.gz --no-check-certificate chef-server/knife_admin_key.tar.gz 
tar xvf /tmp/knife_admin_key.tar.gz -C /chef-repo/.chef

# Work directory
cd /chef-repo

# Verify the access from workstation to server
knife ssl fetch
knife ssl check
knife client list

# Upload the cookbook
knife cookbook upload chef-repo
knife cookbook list

# Bootstrap nodes
knife bootstrap node1 --ssh-user root --ssh-password 'root' --sudo --use-sudo-password --node-name node1 --run-list 'recipe[chef-repo]'
knife bootstrap node2 --ssh-user root --ssh-password 'root' --sudo --use-sudo-password --node-name node2 --run-list 'recipe[chef-repo]'
knife client list
