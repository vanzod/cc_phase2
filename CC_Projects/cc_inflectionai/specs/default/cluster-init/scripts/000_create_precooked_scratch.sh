#!/bin/bash
set euo

mkdir -p /mnt/resource_nvme/data/precooked_scratch
chgrp -R cyclecloud /mnt/resource_nvme/data
chmod -R g+ws /mnt/resource_nvme/data

