#!/bin/bash

# Variables
# Resource Group
ResourceGroup="b1e2-gr1"
Location="westeurope"
Zone="3"
PreName="B1E2-"

# Virtual Network
VNet=$PreName"Network"
AdresseStart="10.0.0.0"
NetworkRange="/16"

# Subnet
Subnet=$PreName"Subnet-Nextcloud"
SubnetRange="/29"

# Virtual Network and subnet Creation
# echo "Virtual Network and subnet Creation"
az network vnet create \
  --name $VNet \
  --resource-group $ResourceGroup \
  --address-prefix $AdresseStart$NetworkRange \
  --subnet-name $Subnet \
  --subnet-prefixes $AdresseStart$SubnetRange