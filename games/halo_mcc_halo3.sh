#!/bin/bash
set -x #echo on

echo "This is not a pure script. You gotta do stuff where it says"
read -p "Press enter to continue"

#install winetricks
sudo apt install winetricks

#install protontricks
#https://github.com/Matoking/protontricks

#had to do this for some reason
rm -rf ~/.local/pipx
python3 -m pip install --user pipx
~/.local/bin/pipx ensurepath
read -p "Should close and reopen terminal and continue here"
pipx install protontricks


#https://www.gamingonlinux.com/2020/07/halo-3-and-halo-reach-may-need-this-audio-fix-on-linux-with-steam-play-proton
protontricks 976730 win7

