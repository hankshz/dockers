#!/bin/bash

set -e

source $(dirname "${BASH_SOURCE[0]}")/common.sh

wget -O /tmp/knife_admin_key.tar.gz --no-check-certificate chef-server/knife_admin_key.tar.gz 
tar xvf /tmp/knife_admin_key.tar.gz -C /chef-repo/.chef

# Work directory
cd /chef-repo

# Verify the access from workstation to server
knife ssl fetch
knife ssl check
knife client list

i=1
while [ $i -lt $N ]
do
    knife bootstrap balancer$i --ssh-user root --ssh-password 'root' --sudo --use-sudo-password --node-name balancer$i
	i=$(( $i + 1 ))
done
i=1
while [ $i -lt $N ]
do
    knife bootstrap web$i --ssh-user root --ssh-password 'root' --sudo --use-sudo-password --node-name web$i
	i=$(( $i + 1 ))
done
knife client list
