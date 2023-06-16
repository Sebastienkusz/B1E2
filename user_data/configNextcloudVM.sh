#!/bin/bash -x

# Variables
LabelAppliIPName="esan-preproduction-nextcloud"
Location="westeurope"

# Fixes
DNSNextcloud=$LabelAppliIPName"."$Location".cloudapp.azure.com"

##Installation Apache + Nextcloud
sudo apt -y update
sudo apt install -y apache2 libapache2-mod-php
sudo apt-get install php libapache2-mod-php php-mysql php-xml php-cli php-gd php-curl php-zip php-mbstring php-bcmath


sudo wget -O /tmp/nextcloud-14.0.14.tar.bz2 https://download.nextcloud.com/server/releases/nextcloud-14.0.14.tar.bz2

sudo tar -xjvf /tmp/nextcloud-14.0.14.tar.bz2 -C /var/www/
sudo chown -R www-data:www-data /var/www/nextcloud
sudo su 
IPPub=$(curl ifconfig.me)
echo "<VirtualHost *:80>
DocumentRoot "/var/www/nextcloud"
ServerName $IPPub
<Directory /var/www/nextcloud>
Require all granted
AllowOverride All
Options FollowSymLinks MultiViews
<IfModule mod_dav.c>
Dav off
</IfModule>
</Directory>
</VirtualHost>" >> /etc/apache2/sites-available/nextcloud.conf
exit
sudo a2dissite 000-default.conf
sudo a2ensite nextcloud.conf
sudo systemctl restart apache2