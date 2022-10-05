#!/bin/bash

# Make sure /mnt/resource is mounted
mount | grep resource || mount /mnt/resource

# Exit if no NVIDIA devices detected
[ -c /dev/nvidia0 ] || exit 0

# Verify that NVIDIA UVM driver is running and device file is present
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#runfile-verifications
# If not, CUDA inside the container will fail
if [ ! -c /dev/nvidia-uvm ]; then
    echo "ERROR: NVIDIA UVM driver is not running. Starting..."
    /sbin/modprobe nvidia-uvm
    if [ "$?" -eq 0 ]; then
        # Find out the major device number used by the nvidia-uvm driver
        D=`grep nvidia-uvm /proc/devices | awk '{print $1}'`
        mknod -m 666 /dev/nvidia-uvm c $D 0
        echo "Started NVIDIA UVM driver."
    else
        echo "ERROR: NVIDIA UVM driver could not be started."
        exit 1
    fi
fi

exit 0
