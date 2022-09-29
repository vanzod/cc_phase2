#!/bin/bash

HPCNODES=$(grep -Po 'Nodes=\K[^ ]+' /sched/cyclecloud.conf | grep hpc)

cp /sched/slurm.conf /tmp/
cat << EOF >> /tmp/slurm.conf
PreemptType=preempt/partition_prio
PreemptMode=REQUEUE
PreemptExemptTime=-1
JobRequeue=1
PartitionName=hpc-high Nodes=${HPCNODES} PriorityTier=65500 Default=NO DefMemPerCPU=18880 MaxTime=INFINITE State=UP
PartitionName=hpc-mid Nodes=${HPCNODES} PriorityTier=32766 Default=YES DefMemPerCPU=18880 MaxTime=INFINITE State=UP
PartitionName=hpc-low Nodes=${HPCNODES} PriorityTier=1 Default=NO DefMemPerCPU=18880 MaxTime=INFINITE State=UP
EOF
sudo cp /tmp/slurm.conf /sched/slurm.conf
rm /tmp/slurm.conf

sudo sed 's/PartitionName=hpc.*/& PreemptMode=OFF Hidden=True/' /sched/cyclecloud.conf

sudo systemctl restart slurmctld
