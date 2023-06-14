#!/bin/bash

sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get install -y apache2 libapache2-mod-php php-gd php-mysql
sudo apt-get install -y php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip
sudo wget https://download.nextcloud.com/server/releases/latest.zip
sudo apt install -y unzip
sudo unzip -d /var/www/html latest.zip


sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo certbot --apache -n --agree-tos -d esan-preproduction-nextcloud01.westeurope.cloudapp.azure.com --register-unsafely-without-email

sudo chown -R www-data:www-data /var/www/html/nextcloud
sudo systemctl restart apache2


sudo chmod 777 /etc/crontab
sudo echo "SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

* 6 * * * root certbot -q renew --apache" >> /etc/crontab

sudo chmod 400 /etc/crontab



