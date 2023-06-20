#!/bin/bash -x

# Variables
PreName="preproduction-"
BDDUrlName=$PreName"bdd-sql"
AdminSQL="adminsql"
AdminPassword="dauphinrouge"
UserSQL="sqluser"
UserPassword="dauphinvert"
BddName="nextcloud"

# Commands
sudo apt -y update
sudo apt install -y mysql-client

sudo mysql -h $BDDUrlName.mysql.database.azure.com -u $AdminSQL -p"$AdminPassword" <<EOF
USE $BddName;
CREATE USER '$UserSQL'@'%' IDENTIFIED BY '$UserPassword';
GRANT ALL PRIVILEGES ON $BddName.* TO '$UserSQL'@'%';
FLUSH PRIVILEGES;
EOF

