#!/bin/bash
set -x #echo on

#script to make sure user home is private

# ensure future users homes are safe
sudo sed -i s/DIR_MODE=0755/DIR_MODE=0750/ /etc/adduser.conf

# then get your own house in order
#note that just changing permission on the home dir impacts everything inside it
#linux permissions need read permisson on parent dirs to be able to read
chmod 750 $HOME


setfacl -m u:libvirt-qemu:rx $HOME


