#!/bin/bash

# Virtual Network and subnet Creation
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$VNet']" -o tsv) != "" ]]
then
  echo "The network already exists"
else
  echo "Creating network"
  az network vnet create \
    --name $VNet \
    --resource-group $ResourceGroup \
    --address-prefix $AdresseStart$NetworkRange \
    --subnet-name $Subnet \
    --subnet-prefixes $AdresseStart$SubnetRange
fi

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$VNet']" -o tsv) == "" ]]
then
  echo "ERROR : The network deployment failed. Starting rollback process."
  az network vnet delete -g $ResourceGroup -n $VNet
  exit 1
else 
  echo "SUCCESS : The network has been deployed"
fi

