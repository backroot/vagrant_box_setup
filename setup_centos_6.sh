#!/bin/bash

set -e

echo "Setup starting."

cat /etc/redhat-release
yum -y install perl perl-core

echo "Setup finished."
