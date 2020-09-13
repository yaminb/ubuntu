#!/bin/bash
set -x #echo on


echo "change:"
echo "from:load-module module-udev-detect"
echo "to:load-module module-udev-detect tsched=0"
sudo nano /etc/pulse/default.pa


