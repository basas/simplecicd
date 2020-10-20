#! /bin/bash
yum update -y
yum install git -y
cd /tmp
wget https://packages.chef.io/files/stable/chef/16.6.14/el/7/chef-16.6.14-1.el7.x86_64.rpm
rpm -ivh chef-16.6.14-1.el7.x86_64.rpm
chef-client --chef-license accept  > /dev/null
/opt/chef/embedded/bin/gem install berkshelf
mkdir -p /tmp/cookbooks
cd /tmp/cookbooks
git clone https://github.com/basas/docker_monitor.git
cd docker_monitor
/opt/chef/embedded/bin/berks vendor /tmp/cookbooks/
cd /tmp
echo '{ "run_list":["docker_monitor::default"] }' > node.json
chef-client -z -j node.json
