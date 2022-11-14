#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SLURM_VERSION=$(apt list --installed | awk '/slurm\// {print $2}')

apt update
apt install -y libhttp-parser-dev libjwt-dev
dpkg -i ${SCRIPT_DIR}/libjson-c2_0.11-4ubuntu2_amd64.deb
dpkg -i ${SCRIPT_DIR}/slurm-slurmrestd_${SLURM_VERSION}_amd64.deb
dpkg -i ${SCRIPT_DIR}/slurm_${SLURM_VERSION}_amd64.deb
