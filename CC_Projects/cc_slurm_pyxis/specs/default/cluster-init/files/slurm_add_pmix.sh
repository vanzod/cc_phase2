#!/bin/bash

DIR_BASE=/shared/home/cycleadmin

mkdir -p /opt/pmix/v3
apt install -y libevent-dev
cd /tmp
tar xvf $CYCLECLOUD_SPEC_PATH/files/openpmix-3.1.6.tar.gz
cd openpmix-3.1.6
./autogen.sh
./configure --prefix=/opt/pmix/v3
make -j install > /dev/null
rm -rf openpmix-3.1.6

systemctl stop slurmd || echo "failed step 0"
sleep 2
apt install -y ${DIR_BASE}/blobs/slurm_20.11.7-1_amd64.deb || echo "failed step 1"
sleep 2
systemctl start slurmd || echo "failed step 2"
