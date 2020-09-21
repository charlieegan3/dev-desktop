#!/usr/bin/env bash

set -euo pipefail

: "${RCLONE_CONFIG:?need rclone config to upload image}"

# this script is run by packer in the VM, it installs:
# - livecd-tools in order to build the iso
# - make to run the build process
# - rclone to upload the image
# - git get the sha for the makefile (not strictly required)

set -exo pipefail

(set +x; echo "$RCLONE_CONFIG" | base64 -d > rclone.conf)

cd /build

dnf install make
make all
