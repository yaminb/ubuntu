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


