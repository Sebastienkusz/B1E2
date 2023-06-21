#!/bin/bash -x

# Variables
LabelAppliIPName="esan-preproduction-nextcloud"
Location="westeurope"
Mailaddress="kusz.sebastien@gmail.com"
PreName="preproduction-"
BddName="nextcloud"
AdminNextcloudName="Nextcloud2023"
AdminNextcloudPass="Nextcloud#2023"
BddDir="/data"
UserSQL="sqluser"
UserSQLPassword="dauphinvert"
SuffixBddUrl=".mysql.database.azure.com"
BddUrlName=$PreName"bdd-sql"$SuffixBddUrl

# Fixes
DNSNextcloud=$LabelAppliIPName"."$Location".cloudapp.azure.com"

# Installation Apache + Nextcloud
sudo apt -y update
sudo apt -y update
sudo apt install -y apache2 libapache2-mod-php
sudo apt install -y php libapache2-mod-php php-mysql php-xml php-cli php-gd php-curl php-zip php-mbstring php-bcmath
sudo wget -O /tmp/latest.tar.bz2 https://download.nextcloud.com/server/releases/latest.tar.bz2
sudo tar -xjvf /tmp/latest.tar.bz2 -C /var/www/
sudo chown -R www-data:www-data /var/www/nextcloud 
IPPub=$(curl ifconfig.me)
sudo echo "<VirtualHost *:80>
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
a2dissite 000-default.conf
a2ensite nextcloud.conf
systemctl reload apache2
cd /var/www/nextcloud/
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
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --apache -d $DNSNextcloud --agree-tos -m $Mailaddress -n

sudo chmod 777 /etc/crontab
sudo echo "SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* 6 * * * root certbot -q renew --apache" >> /etc/crontab

sudo chmod 400 /etc/crontab