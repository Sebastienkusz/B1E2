#!/bin/bash

# Update Network for Mysql service
# az network vnet subnet update \
#     --resource-group $ResourceGroup \
#     --name $Subnet \
#     --vnet-name $VNet \
#     --delegations Microsoft.Sql/managedInstances

# Creating Mysql flexible server
if [[ $(az resource list --query "[?name == '$BDDName' && resourceGroup == '$ResourceGroup']") != '[]' ]] 
then
    echo "The MySQLserver already exists."
else
    echo "Creating MySQLserver."
    az mysql flexible-server create \
        --resource-group $ResourceGroup \
        -n $BDDName \
        --location $Location \
        --vnet $VNet \
        --version 8.0.21 \
        -u adminsql \
        -p "dauphinrouge" \
        --yes
fi

#Testing if the deployment was successful
if [[ $(az resource list --query "[?name == '$BDDName' && resourceGroup == '$ResourceGroup']") == '[]' ]] 
then
    echo "ERROR : The MySQLserver deployment failed. Starting rollback process."
    az mysql flexible-server delete -g $ResourceGroup -n $BDDName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    ps -ef | grep ./00_deploy.sh | grep -v grep | awk '{print $2}' | xargs kill
    ps -ef | grep ./02_bdd.sh | grep -v grep | awk '{print $2}' | xargs kill
else
    echo "SUCCESS : The MySQLserver has been deployed."
fi

# Creating Mysql DB
if [[ $(az resource list --query "[?name == '$BDDName' && resourceGroup == '$ResourceGroup']") != '[]' ]] 
then
  echo "The MySQLserver Nextcloud-database already exists."
else
  echo "Creating MySQLserver Nextcloud-database."
    az mysql flexible-server db create \
        --resource-group $ResourceGroup \
        --server-name $BDDName \
        --database-name nextcloud 
fi

#Testing if the deployment was successful
if [[ $(az resource list --query "[?name == '$BDDName' && resourceGroup == '$ResourceGroup']") == '[]' ]] 
then
    echo "ERROR : The MySQLserver Nextcloud-database deployment failed. Starting rollback process."
    az mysql flexible-server delete -g $ResourceGroup -n $BDDName
    az network vnet delete -g $ResourceGroup -n $VNet
    ps -ef | grep ./00_deploy.sh | grep -v grep | awk '{print $2}' | xargs kill --yes
    ps -ef | grep ./02_bdd.sh | grep -v grep | awk '{print $2}' | xargs kill
else
    echo "SUCCESS : The MySQLserver Nextcloud-database has been deployed."
fi


# Unset ssl certificat Mysql
az mysql flexible-server parameter set \
    --resource-group $ResourceGroup \
    --server-name $BDDName \
    --name "require_secure_transport" \
    --value "OFF"