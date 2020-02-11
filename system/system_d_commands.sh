#!/bin/bash
set -x #echo on

systemctl start service-name
systemctl stop apache2
systemctl restart apache2
systemctl status apache2


systemctl disable apache2
systemctl is-enabled apache2

#force disable... cannot start
systemctl mask service-name

#edit systemd startup timer
#timers located in /etc/systemd/system/timers.target.wants
#set to boot X minutes after start

#[Timer]
##start 3 minutes after boot
#OnBootSec=3m

