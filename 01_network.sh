#!/bin/bash

# Virtual Network and subnet Creation
az network vnet create \
  --name $VNet \
  --resource-group $ResourceGroup \
  --address-prefix $AdresseStart$NetworkRange \
  --subnet-name $Subnet \
  --subnet-prefixes $AdresseStart$SubnetRange

# Network Interface Card Creation
az network nic create \
    --resource-group $ResourceGroup \
    --name $Nic \
    --vnet-name $VNet \
    --subnet $Subnet