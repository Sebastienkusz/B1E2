#!/bin/bash

sudo snap install nextcloud
sudo nextcloud.manual-install nab password
sudo nextcloud.occ config:system:set trusted_domains 1 --value=esan-preproduction-nextcloudnab.westeurope.cloudapp.azure.com
sudo nextcloud.enable-https lets-encrypt