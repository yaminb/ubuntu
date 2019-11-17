#!/bin/bash
set -x #echo on

echo "#WaylandEnable=false"
read -p "Press enter to continue"


sudo vi /etc/gdm3/custom.conf
