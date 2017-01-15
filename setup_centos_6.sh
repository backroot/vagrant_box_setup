#!/bin/bash

set -e

echo "Setup starting."

cat /etc/centos-release

# Perl Install
yum -y install perl perl-core

# Network Configuration
perl -pi -e "s/^ONBOOT=no/ONBOOT=yes/i" /etc/sysconfig/network-scripts/ifcfg-eth0
service network restart
ifconfig

# Vagrant user create
useradd -g wheel vagrant
id vagrant
echo "vagrant" | passwd vagrant --stdin




echo "Setup finished."
