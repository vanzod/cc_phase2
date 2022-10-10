# Set of common functions used across scripts

function is_slurm_controller() {
   systemctl list-units --full -all | grep -q slurmctld
}

function is_slurm_node() {
   systemctl list-units --full -all | grep -q slurmd
}

function is_login_node() {
   RC1=is_slurm_controller
   RC2=is_login_node
   if [ $RC1 -eq 1 ] && [ $RC2 -eq 1 ]; then
      return 0
   else
      return 1
   fi
}
