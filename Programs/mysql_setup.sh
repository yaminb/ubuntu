#!/bin/bash
set -x #echo on

echo "This is not a proper script but a collection of commands"

#install mysql server
sudo apt install mysql-server

#Login using ubuntu initial password
#https://stackoverflow.com/questions/42421585/default-password-of-mysql-in-ubuntu-server-16-04
sudo cat /etc/mysql/debian.cnf

#START MYSQL SESSION
mysql -u debian-sys-maint -p

USE mysql;
SELECT User, Host, plugin FROM mysql.user;

#set new root password
#https://www.percona.com/blog/2016/03/16/change-user-password-in-mysql-5-7-with-plugin-auth_socket/
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';
COMMIT;
#END MYSQL SESSION (exit)

sudo service mysql restart
