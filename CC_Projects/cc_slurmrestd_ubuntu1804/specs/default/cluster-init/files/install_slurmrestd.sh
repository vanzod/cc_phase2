#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

apt update
apt install -y libhttp-parser-dev libjwt-dev
dpkg -i ${SCRIPT_DIR}/libjson-c2_0.11-4ubuntu2_amd64.deb
dpkg -i ${SCRIPT_DIR}/slurm-slurmrestd_20.11.7-1_amd64.deb
dpkg -i ${SCRIPT_DIR}/slurm_20.11.7-1_amd64.deb
