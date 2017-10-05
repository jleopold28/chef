#!/bin/bash

systemctl disable firewalld
systemctl stop firewalld

yum -y install wget

if [ ! -f /tmp/chefdk*.rpm ]; then
  wget https://packages.chef.io/files/stable/chefdk/2.3.4/el/7/chefdk-2.3.4-1.el7.x86_64.rpm -P /tmp
  rpm -Uvh /tmp/chefdk*.rpm
fi

cat >> /etc/hosts <<EOL
192.168.123.10 chef-server
192.168.123.11 node1
192.168.123.12 node2
192.168.123.13 node3
192.168.123.14 workstation
EOL

if [[ $(systemctl get-default) != 'graphical.target' ]]; then
  yum -y group install "Server With GUI"
  systemctl set-default graphical.target
  reboot
fi
