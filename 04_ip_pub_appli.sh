#!/bin/bash

# Variables
# Resource Group
ResourceGroup="b1e2-gr1"
Zone="3"
PreName="B1E2-"

# Public IP VM Application Variables
AppliIPName=$PreName"VM-Appli-IP"

# Public IP VM Application Creation
echo "Public IP VM Application Creation"
az network public-ip create \
    --resource-group $ResourceGroup \
    --name $AppliIPName \
    --version IPv4 \
    --sku Standard \
    --zone $Zone