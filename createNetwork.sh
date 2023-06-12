#!/bin/bash

#Création du network security group qui sera ensuite associé à la VM Bastion
az network nsg create \
  --resource-group Nabila_R \
  --name testnsg 

#Création du network security group qui sera ensuite associé à la VM Nextcloud
az network nsg create \
  --resource-group Nabila_R \
  --name testnsg1

#Création de la règle de filtrage IP et d'accès SSH sur le port 10022
az network nsg rule create \
  --resource-group Nabila_R \
  --nsg-name testnsg \
  --name SSHrule \
  --protocol tcp \
  --direction inbound \
  --priority 1000 \
  --source-address-prefix 82.126.234.200\
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range 10022 \
  --access allow \

#Création d'une règle pour ouvrir l'accès au port 80 de la VM Nextcloud
az network nsg rule create \
  --resource-group Nabila_R \
  --nsg-name testnsg1 \
  --name HTTPrule \
  --protocol tcp \
  --direction inbound \
  --priority 1000 \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range 80 \
  --access allow \


#Création d'une règle pour ouvrir l'accès au port 443 de la VM Nextcloud
az network nsg rule create \
  --resource-group Nabila_R \
  --nsg-name testnsg1 \
  --name HTTPSrule \
  --protocol tcp \
  --direction inbound \
  --priority 900 \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range 443 \
  --access allow \

#Création du réseau 
az network vnet create \
  --name testauto-VNet \
  --resource-group Nabila_R \
  --address-prefix 192.168.0.0/16 \
  --network-security-group testnsg 

#Création du sous-réseau
az network vnet subnet create \
  --name testauto-subnet \
  --resource-group Nabila_R \
  --vnet-name testauto-VNet \
  --address-prefix 192.168.0.0/24




