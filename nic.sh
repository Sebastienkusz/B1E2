#!/bin/bash

# Variables
# Resource Group
ResourceGroup="Sebastien_K"
PreName="W-B1E2-"

# Virtual Network
VNet=$PreName"Network"

# Subnet
Subnet=$PreName"Subnet-Nextcloud"

# Network Interface Card Variables
Nic=$PreName"Nic"


# Network Interface Card Creation
echo "Public IP VM Bastion Creation"
az network nic create \
    --resource-group $ResourceGroup \
    --name $Nic \
    --vnet-name $VNet \
    --subnet $Subnet