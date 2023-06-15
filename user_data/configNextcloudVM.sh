#!/bin/bash

sudo apt-get -y update 
sudo apt-get install -y apache2 libapache2-mod-php php-gd php-mysql
sudo apt-get install -y php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip
sudo wget https://download.nextcloud.com/server/releases/latest.zip
sudo apt install -y unzip
sudo unzip -d /var/www/html latest.zip


sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo certbot --apache -n --agree-tos -d esan-preproduction-nextcloud01.westeurope.cloudapp.azure.com --register-unsafely-without-email
echo "<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/nextcloud/
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
RewriteEngine on
RewriteCond %{SERVER_NAME} =esan-preproduction-nextcloud01.westeurope.cloudapp.azure.com
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>
<IfModule mod_ssl.c>
<VirtualHost *:443>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/nextcloud/
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
ServerName esan-preproduction-nextcloud01.westeurope.cloudapp.azure.com
SSLCertificateFile /etc/letsencrypt/live/esan-preproduction-nextcloud01.westeurope.cloudapp.azure.com/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/esan-preproduction-nextcloud01.westeurope.cloudapp.azure.com/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>" > /etc/apache2/sites-available/nextcloud.conf

sudo a2ensite nextcloud.conf
sudo a2dissite 000-default.conf 
sudo a2dissite 000-default-le-ssl.conf
sudo chown -R www-data:www-data /var/www/html/nextcloud
sudo systemctl restart apache2


sudo chmod 777 /etc/crontab
sudo echo "SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

* 6 * * * root certbot -q renew --apache" >> /etc/crontab

sudo chmod 400 /etc/crontab



