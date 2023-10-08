#!/bin/bash
set -x #echo on

#this can be helpful in some cases
# in my case, it fixed various startup issues with snapd
sudo apt install --reinstall linux-generic linux-image-generic
