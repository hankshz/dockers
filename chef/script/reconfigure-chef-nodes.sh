#!/bin/bash

set -e

source $(dirname "${BASH_SOURCE[0]}")/common.sh

cd /chef-repo

# Download and upload local cookbook and its dependency
(cd cookbooks/chef-repo; berks install; berks upload --no-ssl-verify)

# Create role balancer and set it to balancer nodes
knife role from file roles/balancer.json
i=1
while [ $i -lt $N ]
do
    knife node run_list set balancer$i "role[balancer]"
	i=$(( $i + 1 ))
done

# Update balancer nodes
knife ssh 'role:balancer' 'chef-client' --ssh-user root --ssh-password 'root'

# Create role web and set it to web nodes
knife role from file roles/web.json
i=1
while [ $i -lt $N ]
do
    knife node run_list set web$i "role[web]"
	i=$(( $i + 1 ))
done

# Update web nodes
knife ssh 'role:web' 'chef-client' --ssh-user root --ssh-password 'root'
