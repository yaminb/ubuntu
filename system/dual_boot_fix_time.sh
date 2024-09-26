#!/bin/bash
#https://itsfoss.com/wrong-time-dual-boot/
#In a dual boot setup, this configures linux to localtime so Windows and Linux
#keep the same time.

set -x #echo on

sudo timedatectl set-local-rtc 1

