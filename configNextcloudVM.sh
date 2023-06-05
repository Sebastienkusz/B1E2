#!/bin/bash


sudo apt update && sudo apt upgrade
sudo apt install -y apache2 mariadb-server libapache2-mod-php php-gd php-mysql \
php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip
sudo wget https://download.nextcloud.com/server/releases/latest.zip
sudo apt install unzip
sudo unzip -d /var/www/html latest.zip



sudo touch /etc/apache2/sites-available/nextcloud.conf

sudo chmod 777 /etc/apache2/sites-available/nextcloud.conf

sudo echo "<VirtualHost *:80>
DocumentRoot /var/www/html/nextcloud/
ServerName ESAN
<Directory /var/www/html/nextcloud/>
Require all granted
AllowOverride All
Options FollowSymLinks MultiViews
<IfModule mod_dav.c>
Dav off
</IfModule>
</Directory>
</VirtualHost>" > /etc/apache2/sites-available/nextcloud.conf

sudo a2dissite 000-default.conf
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
sudo chown -R www-data:www-data /var/www/html/nextcloud