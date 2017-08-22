# the default node number is 3
# if you want to change the number, you also need to update ../chef-repo/cookbooks/chef-repo/templates/load-balancer.conf.erb

N=${1:-4}
