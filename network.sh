#!/bin/bash

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
  ps -ef | grep ./00_deploy.sh | grep -v grep | awk '{print $2}' | xargs kill
  ps -ef | grep ./01_network.sh | grep -v grep | awk '{print $2}' | xargs kill
else 
  echo "SUCCESS : The network has been deployed"
fi


ps -ef | grep ./01_network.sh | grep -v grep | awk '{print $2}' | xargs kill

# Network Interface Card Creation
# az network nic create \
#   --resource-group $ResourceGroup \
#   --name $Nic \
#   --vnet-name $VNet \
#   --subnet $Subnet