current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'admin'
validation_client_name   'myorg-validator'
client_key               "#{current_dir}/admin.pem"
validation_key           "#{current_dir}/myorg-validator.pem"
chef_server_url          'https://chef-server/organizations/myorg'
cookbook_path            ["#{current_dir}/../cookbooks"]
