#!/bin/bash

## CentOS 6 setup script for vagrant box

set -e

echo "Setup starting."

cat /etc/centos-release

# Perl install
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
yum -y install perl perl-core

# Kernel devel install
yum -y update kernel
yum -y install kernel-devel kernel-headers gcc gcc-c++

# Network setup
IFCFG_ETH0=/etc/sysconfig/network-scripts/ifcfg-eth0
perl -pi -e "s/^ONBOOT=no/ONBOOT=yes/i" $IFCFG_ETH0
perl -pi -e "s/^HWADDR=.+\n//i" $IFCFG_ETH0
perl -pi -e "s/^UUID=.+\n//i" $IFCFG_ETH0
ln -fs /dev/null /etc/udev/rules.d/70-persistent-net.rules
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
curl -k -L -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:wheel /home/vagrant/.ssh

# SSHD speed up
perl -pi -e "s/^#UseDNS\s+yes/#UseDNS yes\nUseDNS no/i" /etc/ssh/sshd_config
service sshd restart

# sudo setup
perl -pi -e "s/#\s+%wheel[\s|\t]+ALL=\(ALL\)[\s|\t]+NOPASSWD:[\s|\t]+ALL/%wheel  ALL=(ALL)   NOPASSWD: ALL/i" /etc/sudoers
perl -pi -e "s/^Defaults[\s|\t]+requiretty/#Defaults    requiretty/i"  /etc/sudoers

# selinux setup
perl -pi -e "s/^SELINUX=.+/SELINUX=disabled/i" /etc/sysconfig/selinux

# iptables setup
chkconfig iptables off
chkconfig ip6tables off

# yum setup
yum -y install epel-release
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
yum -y install http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
perl -pi -e "s/enabled=1/enabled=0/ig" /etc/yum.repos.d/epel.repo
perl -pi -e "s/enabled=1/enabled=0/ig" /etc/yum.repos.d/remi-safe.repo
yum clean all

# Optimize box size
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo "Setup finished."

shutdown -r now
