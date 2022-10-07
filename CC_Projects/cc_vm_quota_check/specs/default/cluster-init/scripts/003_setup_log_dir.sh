#!/bin/bash

# Only on scheduler VM
if [[ $HOSTNAME =~ "scheduler" ]]; then
    mkdir -p /sched/logs
    chmod 777 /sched/logs
fi
