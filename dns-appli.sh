#!/bin/bash

# Variables
# Resource Group
ResourceGroup="b1e2-gr1"
PreName="B1E2-"

# Public IP VM Application Variables
AppliIPName=$PreName"VM-Appli-IP"

# Label Public IP VM Application Variables
LabelAppliIPName="esan-preproduction-nextcloud"

# Label Public IP VM Application Update
echo "Label Public IP VM Application Update"
az network public-ip update \
 --resource-group $ResourceGroup \
 --name $AppliIPName \
 --dns-name $LabelAppliIPName \
 --allocation-method Static