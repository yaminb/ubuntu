#!/bin/bash
#simple script to show what type of session you are running
#useful for debugging x11/wayland things
set -x #echo on



loginctl show-session 2 -p Type         
