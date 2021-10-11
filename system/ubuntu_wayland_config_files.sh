#!/bin/bash
#This is not a proper script. Just hints on files to configure for wayland
set -x #echo on

#commend out GOTO="gdm_prefer_xorg"
sudo vi /lib/udev/rules.d/61-gdm.rules

#GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"
sudo vi /etc/default/grub


sudo update-grub

