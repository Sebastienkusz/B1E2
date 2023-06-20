#!/bin/bash
echo $($(az resource list --query "[?name == '$VNet' && resourceGroup == '$ResourceGroup']") != '[]')
# Virtual Network and subnet Creation
if [[ $(az resource list --query "[?name == '$VNet' && resourceGroup == '$ResourceGroup']") != '[]' ]]
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
if [[ $(az resource list --query "[?name == '$VNet' && resourceGroup == '$ResourceGroup']") == '[]' ]];
then
  echo "ERROR : The network deployment failed. Starting rollback process."
  az network vnet delete -g $ResourceGroup -n $VNet
  exit 1
else 
  echo "SUCCESS : The network has been deployed"
fi


# Network Interface Card Creation
# az network nic create \
#   --resource-group $ResourceGroup \
#   --name $Nic \
#   --vnet-name $VNet \
#   --subnet $Subnet