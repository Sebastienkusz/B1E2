#!/bin/bash -x

sudo apt -y update
sudo apt install -y mysql-client

sudo echo "USE nextcloud;" | mysql -h dsi-bdd-sql02.mysql.database.azure.com -u nabila -p"password0606!" 
sudo echo "CREATE USER 'sqluser'@'%' IDENTIFIED BY 'password';" | mysql -h dsi-bdd-sql02.mysql.database.azure.com -u nabila -p"password0606!" 
sudo echo "GRANT ALL PRIVILEGES ON nextcloud.* TO 'sqluser'@'%';" | mysql -h dsi-bdd-sql02.mysql.database.azure.com -u nabila -p"password0606!"
sudo echo "FLUSH PRIVILEGES;" | mysql -h dsi-bdd-sql02.mysql.database.azure.com -u nabila -p"password0606!"

#Ajout du certificat SSL Azure pour la base de donnees
#sudo wget --no-check-certificate -O /var/www/html/nextcloud/DigiCertGlobalRootCA.crt.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem  
