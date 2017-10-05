#!/bin/bash

# Shutdown firewall
systemctl disable firewalld
systemctl stop firewalld

# Install wget
if ! rpm -qa | grep wget; then
  yum -y install wget
fi

chown -R vagrant:vagrant /home/vagrant
if [ ! -d "/home/vagrant/certs" ]; then
  mkdir /home/vagrant/certs
fi

# Download and install Chef Server RPM
if ! rpm -qa | grep chef-server-core; then
  wget https://packages.chef.io/files/stable/chef-server/12.16.14/el/7/chef-server-core-12.16.14-1.el7.x86_64.rpm -P /tmp
  rpm -Uvh /tmp/chef-server-core-*.rpm
  
  # Start all services, Configure Server
  chef-server-ctl reconfigure
  chef-server-ctl user-create james James Leopold jleopold@shadow-soft.com password --filename /home/vagrant/certs/james.pem
  chef-server-ctl org-create cheflab "Chef Lab Org" --association_user james --filename /home/vagrant/certs/cheflab-validator.pem

  # Installing Chef Manage
  chef-server-ctl install chef-manage
  chef-server-ctl reconfigure
  chef-manage-ctl reconfigure --accept-license

  # Install Reporting
  chef-server-ctl install opscode-reporting
  chef-server-ctl reconfigure
  opscode-reporting-ctl reconfigure --accept-license

  chef-server-ctl install chef-manage
fi

if ! grep -q "192.168.123.10 chef-server" /etc/hosts; then
cat >> /etc/hosts <<EOL
192.168.123.10 chef-server
192.168.123.11 node1
192.168.123.12 node2
192.168.123.13 node3
192.168.123.14 workstation
EOL
fi

echo "Chef Console is ready: https://chef-server with login: james password: password"
