#!/bin/bash

chmod +x $CYCLECLOUD_SPEC_PATH/files/install_enroot.sh
$CYCLECLOUD_SPEC_PATH/files/install_enroot.sh

chmod +x $CYCLECLOUD_SPEC_PATH/files/install_enroot_hooks.sh
$CYCLECLOUD_SPEC_PATH/files/install_enroot_hooks.sh
