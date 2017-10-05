#!/bin/bash

# Disable and Stop Firewall
systemctl disable firewalld
systemctl stop firewalld

# Install wget
if ! rpm -qa | grep wget; then
  yum -y install wget
fi

if ! rpm -qa | grep chefdk; then
  wget https://packages.chef.io/files/stable/chefdk/2.3.4/el/7/chefdk-2.3.4-1.el7.x86_64.rpm -P /tmp
  rpm -Uvh /tmp/chefdk*.rpm
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

if [[ $(systemctl get-default) != 'graphical.target' ]]; then
  yum -y group install "Server With GUI"
  systemctl set-default graphical.target
  reboot
fi
