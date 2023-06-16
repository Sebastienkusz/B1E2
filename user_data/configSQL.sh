#!/bin/bash -x

# Variables
PreName="preproduction-"
BDDUrlName=$PreName"bdd-sql"
User="nabila"
Password="password0606!"
BddName="nextcloud"

# Commands
sudo apt -y update
sudo apt install -y mysql-client

sudo mysql -h $BDDUrlName.mysql.database.azure.com -u $User -p"$Password" <<EOF
USE $BddName;
CREATE USER '$User'@'%' IDENTIFIED BY '$Password';
GRANT ALL PRIVILEGES ON $BddName.* TO '$User'@'%';
FLUSH PRIVILEGES;
EOF

#Ajout du certificat SSL Azure pour la base de donnees
#sudo wget --no-check-certificate -O /var/www/html/nextcloud/DigiCertGlobalRootCA.crt.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem  