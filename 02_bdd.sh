#!/bin/bash



az network vnet subnet update \
    --resource-group $ResourceGroup \
    --name $Subnet\
    --vnet-name $VNet \
    --delegations Microsoft.Sql/managedInstances


az mysql flexible-server create \
    --resource-group $ResourceGroup\
    -n $BDDName \
    --location $Location\
    --vnet $VNet\
    --version 8.0.21\
    -u $Username \
    -p password0606! \
    --yes



az mysql flexible-server db create \
    --resource-group $ResourceGroup \
    --server-name $BDDName  \
    --database-name nextcloud 



