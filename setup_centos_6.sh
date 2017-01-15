#!/bin/bash

## CentOS 6 setup script for vagrant box

set -e

echo "Setup starting."

cat /etc/centos-release

# Perl Install
yum -y install perl perl-core

# Network Configuration
IFCFG_ETH0=/etc/sysconfig/network-scripts/ifcfg-eth0
perl -pi -e "s/^ONBOOT=no/ONBOOT=yes/i" $IFCFG_ETH0
cat $IFCFG_ETH0
service network restart
ifconfig

# Vagrant user create
useradd -g wheel vagrant
id vagrant
echo "vagrant" | passwd vagrant --stdin




echo "Setup finished."
