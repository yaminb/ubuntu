#!/bin/bash

set -x #echo on

#normally this is due to some package not installing.... try reinstall
#sudo apt install --reinstall linux-modules-extra-5.3.0-24-generic

sudo apt --fix-broken install
sudo apt autoremove
sudo apt autoclean
sudo apt-get update --fix-missing
sudo dpkg --configure -a
sudo apt-get install -f

