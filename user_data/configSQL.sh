#!/bin/bash -x

###################################### SCRIPT CONFIGURATION DE LA BASE DE DONNEES + AJOUT CERTIFICAT SSL AZURE ###############################################

#Ajout du certificat SSL Azure pour la base de données
sudo wget --no-check-certificate -O /var/www/html/nextcloud/DigiCertGlobalRootCA.crt.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem  


sudo apt -y update
sudo apt install -y mysql-client

sudo echo "USE nextcloud;" | mysql -h dsi-bdd-sql.mysql.database.azure.com -u nabila -p"password0606!" 
sudo echo "CREATE USER 'sqluser'@' %' IDENTIFIED BY 'password';" | mysql -h dsi-bdd-sql.mysql.database.azure.com -u nabila -p"password0606!" 
sudo echo "GRANT ALL PRIVILEGES ON nextcloud.* TO 'sqluser'@'%';" | mysql -h dsi-bdd-sql.mysql.database.azure.com -u nabila -p"password0606!"
sudo echo "FLUSH PRIVILEGES;" | mysql -h dsi-bdd-sql.mysql.database.azure.com -u nabila -p"password0606!"

#A modifier 
# echo "  'dbdriveroptions' => array(
#      PDO::MYSQL_ATTR_SSL_CA => '/var/www/html/nextcloud/DigiCertGlobalRootCA.crt.pem',
#     ),">> /var/www/html/nextcloud/config/config.php
