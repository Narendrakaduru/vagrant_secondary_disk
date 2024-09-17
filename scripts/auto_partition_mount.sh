#!/bin/bash

# Variables
DISK="/dev/sdb"
PARTITION="${DISK}1"
MOUNT_POINT="/hdd"

# Check if the disk exists
if [ ! -b "$DISK" ]; then
  echo "Disk $DISK not found!"
  exit 1
fi

# Unmount if already mounted
sudo umount $PARTITION 2>/dev/null

# Create partition on the disk
echo "Creating partition on $DISK..."
(
echo n      # Add a new partition
echo p      # Primary partition
echo 1      # Partition number 1
echo        # Default - start at first sector
echo        # Default - end at last sector
echo w      # Write changes
) | sudo fdisk $DISK

# Format the partition with ext4 filesystem
echo "Formatting $PARTITION with ext4..."
sudo mkfs.ext4 $PARTITION

# Create mount point if not exists
if [ ! -d "$MOUNT_POINT" ]; then
  echo "Creating mount point at $MOUNT_POINT..."
  sudo mkdir -p $MOUNT_POINT
fi

# Mount the partition
echo "Mounting $PARTITION to $MOUNT_POINT..."
sudo mount $PARTITION $MOUNT_POINT

# Get UUID of the partition
UUID=$(sudo blkid -s UUID -o value $PARTITION)

# Backup fstab
echo "Backing up /etc/fstab..."
sudo cp /etc/fstab /etc/fstab.bak

# Add partition to fstab for auto-mounting on boot
echo "Adding $PARTITION to /etc/fstab..."
if ! grep -q "$UUID" /etc/fstab; then
  echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 2" | sudo tee -a /etc/fstab
fi

# Remount to verify fstab
echo "Verifying fstab with mount -a..."
sudo mount -a

# Confirm
echo "Partition $PARTITION is mounted on $MOUNT_POINT and added to /etc/fstab."
