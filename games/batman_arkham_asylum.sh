#!/bin/bash
set -x #echo on

echo "This is not a pure script. You gotta do stuff where it says"
read -p "Press enter to continue"

#install winetricks
sudo apt install winetricks

#install protontricks
#https://github.com/Matoking/protontricks
python3 -m pip install --user pipx
~/.local/bin/pipx ensurepath
read -p "Should close and reopen terminal and continue here"
pipx install protontricks


#https://www.protondb.com/app/35140
echo "set game launch options to: PROTON_NO_ESYNC=1 PROTON_USE_D9VK=1 %command%"
read -p "Press enter to continue"
protontricks 35140 mdx d3dx9 d3dcompiler_43 win10

echo "#Change to windows XP"
read -p "Press enter to continue"
env WINEPREFIX="~/.steam/steam/steamapps/common/Proton 4.11/dist/share/default_pfx" WINEPATH="~/.steam/steam/steamapps/common/Proton 4.11/dist/bin/wine64" winecfg

