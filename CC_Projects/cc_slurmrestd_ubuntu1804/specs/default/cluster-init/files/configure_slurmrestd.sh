#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo 'AuthAltTypes=auth/jwt' >> /sched/slurm.conf

dd if=/dev/random of=/var/spool/slurmd/jwt_hs256.key bs=32 count=1
chmod 0600 /var/spool/slurmd/jwt_hs256.key
chown slurm:slurm /var/spool/slurmd/jwt_hs256.key

sed -i 's/.*slurmrestd.socket/#&/' /usr/lib/systemd/system/slurmrestd.service
sed -i '/.*SLURM_JWT=daemon/s/.//' /usr/lib/systemd/system/slurmrestd.service
sed -i '/.*6820/s/.//' /usr/lib/systemd/system/slurmrestd.service

systemctl daemon-reload

systemctl restart slurmdbd
systemctl restart slurmctld
systemctl enable slurmrestd
systemctl start slurmrestd
