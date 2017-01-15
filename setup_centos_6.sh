#!/bin/bash

## CentOS 6 setup script for vagrant box

set -e

echo "Setup starting."

cat /etc/centos-release

# Perl Install
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
yum -y install perl perl-core

# Network setup
IFCFG_ETH0=/etc/sysconfig/network-scripts/ifcfg-eth0
perl -pi -e "s/^ONBOOT=no/ONBOOT=yes/i" $IFCFG_ETH0
cat $IFCFG_ETH0
service network restart
ifconfig

# Vagrant user create
useradd -g wheel vagrant
id vagrant
echo "vagrant" | passwd vagrant --stdin

# SSH setup
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
curl -k -L -o authorized_keys https://github.com/mitchellh/vagrant/blob/master/keys/vagrant.pub
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:wheel /home/vagrant/.ssh


echo "Setup finished."
