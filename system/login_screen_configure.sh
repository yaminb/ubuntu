#!/bin/bash
set -x #echo on

echo "#lockDialogGroup {"
echo "background: url(file:///usr/share/backgrounds/mybackground.png);"
read -p "Press enter to continue"


sudo vi /etc/alternatives/gdm3.css

