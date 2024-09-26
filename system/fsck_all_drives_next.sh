#!/bin/bash
set -x #echo on

#just sets fsck to check all drives next reboot
#https://www.linuxuprising.com/2019/05/how-to-force-fsck-filesystem.html

sudo tune2fs -c 1 /dev/sda1
sudo tune2fs -c 1 /dev/sda3
sudo tune2fs -c 1 /dev/sdc3

