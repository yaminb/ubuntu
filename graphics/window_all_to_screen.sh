#!/bin/bash
#set -x #echo on

#simple script to bring all windows not on main screen back to main monitor
#this is useful as 2 monitor setup sometimes results in applications launching
#in the 2nd monitor, which might be powered off

#it works practically, but sometime for some reason a window on the 
#main monitor has a huge xoffset (2000+)that should take it beyond the main 
#monitor, but does not. I'm not sure why that is...

#script variables
X_OFFSET_LIMIT=1900
SIZE_X_NEW=800
SIZE_Y_NEW=600

#end script variables

window_list=$(wmctrl -lG)

#sample output
#0x02000003  0 158  152  1673 884  yamin-desktop Mozilla Firefox

#iterate over all lines
#we need the windowid = 0x02000003
#we need the x offset = 158

while IFS= read -r line; do
	window_id=$(echo $line | cut -f 1 -d " ")
	x_offset1=$(echo $line | cut -f 3 -d " ")
	window_name=$(echo $line | cut -f 8 -d " ")
	
	#if x_offset > some amount (on other screen)
	if [ $x_offset1 -gt $X_OFFSET_LIMIT ]
	then
		echo Moving window back to main screen: $window_name
		#move and resize window safely back to screen
		wmctrl -i -r $window_id -e 0,50,50,$SIZE_X_NEW,$SIZE_Y_NEW

	fi	
done <<< "$window_list"


