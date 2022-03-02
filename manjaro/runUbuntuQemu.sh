#!/usr/bin/env bash

# Not My Creation, credit to https://github.com/cirosantilli/linux-cheat/blob/4c8ee243e0121f9bbd37f0ab85294d74fb6f3aec/ubuntu-18.04.1-desktop-amd64.sh


# Tested on: Ubuntu 18.10.
# https://askubuntu.com/questions/884534/how-to-run-ubuntu-16-04-desktop-on-qemu/1046792#1046792


set -eux

# Parameters.
id=ubuntu-18.04.6-desktop-amd64
disk_img="${id}.img.qcow2"
disk_img_snapshot="${id}.snapshot.qcow2"
iso="${id}.iso"

# Get image.
if [ ! -f "$iso" ]; then
  wget "http://releases.ubuntu.com/bionic/${iso}"
fi

# Go through installer manually.
if [ ! -f "$disk_img" ]; then
  qemu-img create -f qcow2 "$disk_img" 1T
  qemu-system-x86_64 \
    -cdrom "$iso" \
    -drive "file=${disk_img},format=qcow2" \
    -enable-kvm \
    -m 2G \
    -smp 2 \
  ;
fi

# Snapshot the installation.
if [ ! -f "$disk_img_snapshot" ]; then
  qemu-img \
    create \
    -b "$disk_img" \
    -f qcow2 \
    "$disk_img_snapshot" \
    -F qcow2 \
  ;
fi

# Run the installed image.
# The net commands forward the host's port 10022 to the VM's port 22 for ssh
qemu-system-x86_64 \
  -drive "file=${disk_img_snapshot},format=qcow2" \
  -enable-kvm \
  -m 8G \
  -smp 2 \
  -device intel-hda \
  -net nic \
  -net user,hostfwd=tcp::10022-:22 \
  -vga virtio \
  "$@" \
;
