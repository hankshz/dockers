#!/bin/bash

set -e

chef-server-ctl reconfigure
chef-server-ctl user-create admin Admin User admin@myorg.com "password"  --filename /etc/chef/admin.pem
chef-server-ctl org-create myorg "default organization" --association_user admin --filename /etc/chef/myorg-validator.pem

# Enable pem download
sed -i '$i\    location /knife_admin_key.tar.gz {\n      default_type application/zip;\n      alias /etc/chef/knife_admin_key.tar.gz;\n    }' /var/opt/opscode/nginx/etc/chef_https_lb.conf
cd /etc/chef/ && tar -cvzf knife_admin_key.tar.gz admin.pem myorg-validator.pem
chef-server-ctl restart nginx
