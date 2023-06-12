#!/bin/bash

# Variables
# Resource Group
ResourceGroup="b1e2-gr1"
Zone="3"
PreName="B1E2-"

# Public IP VM Bastion Variables
BastionIPName=$PreName"VM-Bastion-IP"

# Public IP VM Bastion Creation
echo "Public IP VM Bastion Creation"
az network public-ip create \
    --resource-group $ResourceGroup \
    --name $BastionIPName \
    --version IPv4 \
    --sku Standard \
    --zone $Zone