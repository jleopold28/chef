#!/bin/bash

systemctl disable firewalld
systemctl stop firewalld

if ! grep -q "192.168.123.10 chef-server" /etc/hosts; then
cat >> /etc/hosts <<EOL
192.168.123.10 chef-server
192.168.123.11 node1
192.168.123.12 node2
192.168.123.13 node3
192.168.123.14 workstation
EOL
fi
