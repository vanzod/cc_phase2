# Requires SUID to be set for scontrol:
# sudo chmod u+s /usr/bin/scontrol

sbatch() {
    /sched/scripts/quota_reservation.sh
    /usr/bin/sbatch $@
}
