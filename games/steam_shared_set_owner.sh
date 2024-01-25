#!/bin/bash

#This script is a bit of a clunky workaround for steam
#if using a shared steam storage (/home/shared_steam), you can't use proton with
#multiple users. Wine will complain that some files are not owned by you. This
#occurs even if the user is added to a group that has all permissions.

#looks related to this: https://github.com/ValveSoftware/Proton/issues/4820

#START_CONFIGURATION
steam_path="/home/shared_steam"
#END_CONFIGURATION


#first show our steamusers
echo "Listing possible users"
getent group steamusers
echo ""
echo ""
echo "Enter the owner name:"  
read new_owner
echo ""
echo "changing owner to: $new_owner on path $steam_path"

sudo chown -R $new_owner $steam_path

