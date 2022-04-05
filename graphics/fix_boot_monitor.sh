#!/bin/bash
#fixes which monitor the login screen is displayed
#first, set the primary monitor in gnome settings (Screen Display Menu)
set -x #echo on

sudo cp ~/.config/monitors.xml /var/lib/gdm3/.config/ 


