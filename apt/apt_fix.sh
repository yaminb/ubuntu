#!/bin/bash

set -x #echo on

sudo apt autoremove
sudo apt autoclean
sudo apt-get update --fix-missing
sudo dpkg --configure -a
sudo apt-get install -f

