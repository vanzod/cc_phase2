#!/bin/bash

echo '*/5 * * * * /sched/scripts/quota_reservation.sh' | sudo tee -a /var/spool/cron/crontabs/root
