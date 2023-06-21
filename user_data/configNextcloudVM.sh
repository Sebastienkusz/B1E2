#!/bin/bash

sudo apt -y update 
sudo apt install -y php php-apcu php-bcmath php-cli php-common php-curl php-gd php-gmp php-imagick php-intl php-mbstring php-mysql php-zip php-xml
sudo wget https://download.nextcloud.com/server/releases/latest.zip
sudo a2enmod dir env headers mime rewrite ssl
sudo apt install -y unzip
sudo unzip -d /nextclouddrive/ latest.zip
sudo chown -R www-data:www-data /nextclouddrive/nextcloud

sudo a2dissite 000-default.conf

sudo echo "<VirtualHost *:80>
        ServerAdmin webmaster@localhost
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

sudo a2ensite nextcloud.conf
sudo systemctl restart apache2

#Give writing rights into the managed disk to web app
sudo -u www-data php /nextclouddrive/nextcloud/occ
sudo chmod 744 /nextclouddrive/nextcloud/occ
cd /nextclouddrive/nextcloud/
sudo -u www-data php occ maintenance:install --database="mysql" --database-name="nextcloud" --database-host="preproduction-bdd-sql.mysql.database.azure.com" --database-user="sqluser" --database-pass="dauphinvert" --data-dir="/nextclouddrive/nextcloud/data"
sudo -u www-data php occ config:system:set trusted_domains 1 --value="enas-preproduction-nextcloud.westeurope.cloudapp.azure.com"


sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --apache -n --agree-tos -d enas-preproduction-nextcloud.westeurope.cloudapp.azure.com --register-unsafely-without-email 

sudo systemctl restart apache2

sudo chmod 777 /etc/crontab
sudo echo "SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* 6 * * * root certbot -q renew --apache" >> /etc/crontab

sudo chmod 400 /etc/crontab