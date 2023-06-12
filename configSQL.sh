#!/bin/bash
###################################### SCRIPT CONFIGURATION DE LA BASE DE DONNEES + AJOUT CERTIFICAT SSL AZURE ###############################################


#Ajout du certificat SSL Azure pour la base de données
sudo wget --no-check-certificate https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem 
sudo mv DigiCertGlobalRootCA.crt.pem /var/www/html/nextcloud/DigiCertGlobalRootCA.crt.pem 

sudo apt-get -y update
sudo apt-get install -y mysql-client

sudo echo "USE nextcloud;" | mysql -h testbdd01.mysql.database.azure.com -u nabila -p"password0606!" 
sudo echo "CREATE USER 'sqluser'@' %' IDENTIFIED BY 'password';" | mysql -h testbdd01.mysql.database.azure.com -u nabila -p"password0606!" 
sudo echo "GRANT ALL PRIVILEGES ON nextcloud.* TO 'sqluser'@'%';" | mysql -h testbdd01.mysql.database.azure.com -u nabila -p"password0606!"
sudo echo "FLUSH PRIVILEGES;" | mysql -h testbdd01.mysql.database.azure.com -u nabila -p"password0606!"

#A modifier 
echo "  'dbdriveroptions' => array(
     PDO::MYSQL_ATTR_SSL_CA => '/var/www/html/nextcloud/DigiCertGlobalRootCA.crt.pem',
    ),">> /var/www/html/nextcloud/config/config.php
