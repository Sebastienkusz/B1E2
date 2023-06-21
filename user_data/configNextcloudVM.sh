#!/bin/bash

# Variables
LabelAppliIPName="enas-preproduction-nextcloud"
Location="westeurope"
PreName="preproduction-"
BddName="nextcloud"
AdminNextcloudName="Nextcloud2023"
AdminNextcloudPass="Nextcloud#2023"
BddDir="/nextclouddrive/nextcloud/data"
UserSQL="sqluser"
UserSQLPassword="dauphinvert"
SuffixBddUrl=".mysql.database.azure.com"
BddUrlName=$PreName"bdd-sql"$SuffixBddUrl

# Fixes
DNSNextcloud=$LabelAppliIPName"."$Location".cloudapp.azure.com"

# Installation Apache + Nextcloud
sudo apt -y update
sudo apt install -y apache2
sudo apt install -y php php-apcu php-bcmath php-cli php-common php-curl php-gd php-gmp php-imagick php-intl php-mbstring php-mysql php-zip php-xml
sudo wget https://download.nextcloud.com/server/releases/latest.zip
sudo a2enmod dir env headers mime rewrite ssl
sudo apt install -y unzip
sudo unzip -d /nextclouddrive/ latest.zip
sudo chown -R www-data:www-data /nextclouddrive/nextcloud


sudo echo "<VirtualHost *:80>
ServerAdmin webmaster@enas-preproduction-nextcloud.westeurope.cloudapp.azure.com
ServerName enas-preproduction-nextcloud.westeurope.cloudapp.azure.com
DocumentRoot /nextclouddrive/nextcloud/
<Directory "/nextclouddrive/nextcloud/">
Options Multiviews FollowSymlinks
Require all granted
Order deny,allow 
AllowOverride All
Allow from all
</Directory>
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/nextcloud.conf
sudo a2dissite 000-default.conf
sudo a2ensite nextcloud.conf
sudo systemctl reload apache2

sudo -u www-data php /nextclouddrive/nextcloud/occ
sudo chmod 744 /nextclouddrive/nextcloud/occ
cd /nextclouddrive/nextcloud/

sudo -u www-data php occ maintenance:install \
    --database="mysql" \
    --admin-user="$AdminNextcloudName" \
    --admin-pass="$AdminNextcloudPass" \
    --database-host="$BddUrlName" \
    --database-name="$BddName" \
    --database-user="$UserSQL" \
    --database-pass="$UserSQLPassword" \
    --data-dir="$BddDir" \
    -n

sudo -u www-data php occ config:system:set trusted_domains 1 --value=$DNSNextcloud
cd
sudo apt -y install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo certbot --apache -d $DNSNextcloud -n --agree-tos --register-unsafely-without-email 

sudo systemctl restart apache2

sudo chmod 777 /etc/crontab
sudo echo "SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* 6 * * * root certbot -q renew --apache" >> /etc/crontab

sudo chmod 400 /etc/crontab
