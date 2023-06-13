#!/bin/bash


##Installation Apache + Nextcloud
sudo apt -y update
sudo apt install -y apache2 mariadb-server libapache2-mod-php php-gd php-mysql \
php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip
sudo wget https://download.nextcloud.com/server/releases/latest.zip
sudo apt install -y unzip
sudo unzip -d /var/www/html latest.zip


##Installation du certificat SSL, avec mise à jour du virtualhost
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo certbot --apache -n --agree-tos -d nextcloud01.westeurope.cloudapp.azure.com --register-unsafely-without-email



sudo sed -i 's+DocumentRoot /var/www/html/+DocumentRoot /var/www/html/nextcloud/+g' /etc/apache2/sites-available/000-default-le-ssl.conf
sudo chown -R www-data:www-data /var/www/html/nextcloud
sudo systemctl restart apache2

#Configuration du renouvellement automatique du certificat SSL
sudo chmod 777 /etc/crontab
sudo echo "SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

* 6 * * * r oot certbot -q renew --apache" >> /etc/crontab

sudo chmod 400 /etc/crontab



