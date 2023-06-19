#!/bin/bash -x

sudo apt -y update
sudo apt install -y mysql-client

sudo echo "USE nextcloud;" | mysql -h preproduction-bdd-sql01.mysql.database.azure.com -u sqladmin -p"dauphinrouge" 
sudo echo "CREATE USER 'sqluser'@'%' IDENTIFIED BY 'dauphinvert';" | mysql -h preproduction-bdd-sql01.mysql.database.azure.com -u sqladmin -p"dauphinrouge" 
sudo echo "GRANT ALL PRIVILEGES ON nextcloud.* TO 'sqluser'@'%';" | mysql -h preproduction-bdd-sql01.mysql.database.azure.com -u sqladmin -p"dauphinrouge"
sudo echo "FLUSH PRIVILEGES;" | mysql -h preproduction-bdd-sql01.mysql.database.azure.com -u sqladmin -p"dauphinrouge"

