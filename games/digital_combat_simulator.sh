#!/bin/bash
set -x #echo on

echo "This is not a pure script. You gotta do stuff where it says"
read -p "Press enter to continue"


#https://www.protondb.com/app/223750
echo "set game launch options to: PROTON_NO_ESYNC=1 PROTON_USE_D9VK=1 %command%"
read -p "Press enter to continue"
protontricks 223750 vcrun2017 corefonts xact d3dcompiler_43


#also set to windows XP as in batmat arkham asylum



