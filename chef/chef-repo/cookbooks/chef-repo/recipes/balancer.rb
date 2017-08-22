directory '/var/www/nginx-default' do
  recursive true
end

template '/var/www/nginx-default/index.html' do
  source 'index.html.erb'
end

template '/etc/nginx/sites-available/default' do
  source 'load-balancer.conf.erb'
  notifies :reload, "service[nginx]", :delayed
end
