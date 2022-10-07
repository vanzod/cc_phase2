#!/bin/bash

# Only on scheduler VM
if [[ $HOSTNAME =~ "scheduler" ]]; then
    cp $CYCLECLOUD_SPEC_PATH/files/quota_reservation.sh /sched/scripts
    chmod 755 /sched/scripts/quota_reservation.sh
fi
