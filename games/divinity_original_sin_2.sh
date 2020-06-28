#!/bin/bash
set -x #echo on


#https://www.reddit.com/r/DivinityOriginalSin/comments/alrg6u/divinity_original_sin_2_de_on_linux_with/

echo "This is not a pure script. You gotta do stuff where it says"
read -p "Press enter to continue"


echo "Once the game is installed, right-click on the game entry and choose Properties -> Local Files"
echo "CD PATH... ex /home/user/.local/share/Steam/steamapps/common/Divinity Original Sin 2"
read -p "Press enter to continue"


mv ./bin ./bin.bak && ln -s DefEd/bin bin && cd bin && mv ./SupportTool.exe ./SupportTool.bak && ln -s EoCApp.exe SupportTool.exe
WINEPREFIX=~/.steam/steam/steamapps/compatdata/435150/pfx/ winetricks xact

