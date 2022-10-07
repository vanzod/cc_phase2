#!/bin/bash

cp $CYCLECLOUD_SPEC_PATH/files/99_sbatch_alias.sh /etc/profile.d
cp $CYCLECLOUD_SPEC_PATH/files/99_srun_alias.sh /etc/profile.d
chmod u+s /usr/bin/scontrol
