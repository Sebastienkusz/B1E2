#!/bin/bash

#Création de la VM Nextcloud
az vm create \
    --resource-group Nabila_R \
    --name NextcloudVM \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username nabila \
    --vnet-name testauto-Vnet \
    --subnet testauto-subnet \
    --nsg testnsg1 \
    --public-ip-address-allocation static \
    --public-ip-address-dns-name nextcloud01 \
    --custom-data configNextcloudVM.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub

#Attache disque sur la VM
az vm disk attach \
    --resource-group Nabila_R \
    --vm-name NextcloudVM \
    --name MyDisk \

#Lancement du montage du disque
az vm run-command invoke \
    --resource-group Nabila_R \
    -n NextcloudVM \
    --command-id RunShellScript \
    --scripts @mountDisk.sh 

#Lancement de la configuration de la base de données
az vm run-command invoke \
    --resource-group Nabila_R \
    -n NextcloudVM \
    --command-id RunShellScript \
    --scripts @configSQL.sh 


