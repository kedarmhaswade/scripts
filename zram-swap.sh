#!/bin/bash
# zram-setup.sh
# Sets up zram as swap, using 25% of RAM

set -euo pipefail

# Load the zram module
if ! lsmod | grep -q '^zram'; then
    sudo modprobe zram
fi

# Create one zram device
if [ ! -e /dev/zram0 ]; then
    echo "Creating zram device..."
    echo 1 | sudo tee /sys/class/zram-control/hot_add
fi

# Compute 25% of total RAM in bytes
TOTAL_RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')  # kB
ZRAM_SIZE=$(( TOTAL_RAM / 4 * 1024 ))                        # bytes

echo "Setting zram disk size to $ZRAM_SIZE bytes..."
echo $ZRAM_SIZE | sudo tee /sys/block/zram0/disksize

# Initialize swap on zram
sudo mkswap /dev/zram0
sudo swapon /dev/zram0

echo "ZRAM swap setup complete."
swapon --show

