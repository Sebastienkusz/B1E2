#!/bin/bash -x

# Variables
PreName="preproduction-"
BddUrlName=$PreName"bdd-sql"
AdminSQL="adminsql"
AdminSQLPassword="dauphinrouge"
UserSQL="sqluser"
UserSQLPassword="dauphinvert"
BddName="nextcloud"

# Commands
sudo apt -y update
sudo apt install -y mysql-client

sudo mysql -h $BddUrlName.mysql.database.azure.com -u $AdminSQL -p"$AdminSQLPassword" <<EOF
USE $BddName;
CREATE USER '$UserSQL'@'%' IDENTIFIED BY '$UserSQLPassword';
GRANT ALL PRIVILEGES ON $BddName.* TO '$UserSQL'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
\q
EOF