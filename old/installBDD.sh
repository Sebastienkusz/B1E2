#!/bin/bash

# Vos variables
resourceGroup="Arnaud_G"
serverName="BDDmylove"
adminLogin="adminbdd"
adminPassword="Bddmylove@love"
location="westeurope"
edition="GeneralPurpose"  # Valeur par défaut : GeneralPurpose. Les autres choix Basic ou BusinessCritical
#visiblement ça marche pas vCores="2"  # Valeur par défaut : 2. Les autres choix 4 ou 8
#quand on enleve ce truc ça marche? computeModel="2"
maxSize="32"  # Valeur par défaut : 32. Les autres choix  64 ou 128


# Création de l'instance Azure SQL dans Azure
az sql server create \
  --name $serverName \
  --resource-group $resourceGroup \
  --location $location \
  --admin-user $adminLogin \
  --admin-password $adminPassword

# Création de la base de données de cette instance Azure SQL
az sql db create \
  --name "love" \
  --resource-group $resourceGroup \
  --server $serverName \
  --edition $edition \
  #lui il faut l'enlever aussi --vcore $vCores \
  --max-size $maxSize
