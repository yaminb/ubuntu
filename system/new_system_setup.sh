#!/bin/bash
#simple script where I'll try to include programs needed on a new system setup
#this will be a best effort
set -x #echo on




#Gnome extensions
#right now these are manually installed via the software store
	#"Sound Input & Output Device Chooser"
	#https://github.com/kgshank/gse-sound...device-chooser

	#Caffeine
	#https://github.com/eonpatapon/gnome-shell-extension-caffeine


#SNAPS
sudo snap install vlc
sudo snap install keepassxc
sudo snap install libreoffice
sudo snap install kolourpaint
sudo snap install obs-studio
sudo snap install discord
sudo snap install chromium




#APT packages
sudo apt-get install virtualbox
#sometimes need to install virtualbox-dkms again after virtual box
sudo apt-get install virtualbox-dkms

sudo apt-get install gnome-software-plugin-flatpak
sudo apt-get install git
sudo apt-get install firefox


#important settings

#Grub timeout
echo "GRUB_TIMEOUT=5"
read -p "Press enter to continue"
sudo vi /etc/default/grub
sudo update-grub

