#!/bin/bash
#this script enables sensors like Fan speed for monitoring
#src: https://www.reddit.com/r/gnome/comments/11fz3rc/vitals_voltage_and_fan_speed_not_showing/
set -x #echo on

//Adding Kernel Parameter via GRUB//
//Find this line GRUB_CMDLINE_LINUX_DEFAULT and append acpi_enforce_resources=lax
//It should look like something like this 
//GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_enforce_resources=lax"
//Save and exit from gedit and run 
sudo gedit /etc/default/grub
sudo update-grub

//upon reboot
//Running sensors-detect//
sudo sensors-detect
//Press Y - y on any dialog prompt



