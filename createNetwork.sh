#!/bin/bash

#Création du network security group 
az network nsg create \
  --resource-group Nabila_R \
  --name testnsg 

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

#Création du réseau 
az network vnet create \
  --name testauto-VNet \
  --resource-group Nabila_R \
  --address-prefix 10.0.0.0/16 \
  --network-security-group testnsg 

#Création du sous-réseau
az network vnet subnet create \
  --name testauto-subnet \
  --resource-group Nabila_R \
  --vnet-name testauto-VNet \
  --address-prefix 10.0.0.0/26


