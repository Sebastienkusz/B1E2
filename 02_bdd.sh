#!/bin/bash

# Creating Mysql flexible server
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$BDDName']" -o tsv) != "" ]] 
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
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$BDDName']" -o tsv) == "" ]] 
then
    echo "ERROR : The MySQLserver deployment failed. Starting rollback process."
    az mysql flexible-server delete -g $ResourceGroup -n $BDDName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    az network private-dns zone delete --name $BDDName.private.mysql.database.azure.com --resource-group $ResourceGroup --yes
    exit 1
else
    echo "SUCCESS : The MySQLserver has been deployed."
fi

# Creating Mysql DB
az mysql flexible-server db create \
    --resource-group $ResourceGroup \
    --server-name $BDDName \
    --database-name nextcloud 


# Unset ssl certificat Mysql
az mysql flexible-server parameter set \
    --resource-group $ResourceGroup \
    --server-name $BDDName \
    --name "require_secure_transport" \
    --value "OFF"