#!/bin/bash
#resolves some boot error messages by disabling usbc connector for graphics card

set -x #echo on

echo "add blacklist ucsi_ccg to file"
read -p "Press [Enter] to edit file..."
sudo vi /etc/modprobe.d/blacklist-nvidia-usb.conf



