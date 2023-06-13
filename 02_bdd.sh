#!/bin/bash



az network vnet subnet update \
    --resource-group $ResourceGroup \
    --name $Subnet\
    --vnet-name $VNet \
    --delegations Microsoft.Sql/managedInstances


az mysql flexible-server create \
    --resource-group $ResourceGroup\
    -n testbdd01 \
    --location westeurope \
    --vnet $VNet\
    --version 8.0.21\
    -u nabila \
    -p password0606! \
    --yes



az mysql flexible-server db create \
    --resource-group $ResourceGroup \
    --server-name testbdd01  \
    --database-name nextcloud 



