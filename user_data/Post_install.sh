#!/bin/bash -x

# Variables
LabelAppliIPName="esan-preproduction-nextcloud"
Location="westeurope"
Mailaddress="kusz.sebastien@gmail.com"

# Fixes
DNSNextcloud=$LabelAppliIPName"."$Location".cloudapp.azure.com"

cd /var/www/nextcloud
sudo -u www-data php occ config:system:set trusted_domains 1 --value=$DNSNextcloud

cd
sudo apt -y install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --apache -d $DNSNextcloud --agree-tos -m $Mailaddress -n