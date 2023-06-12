#!/bin/bash

# Variables
# Resource Group
ResourceGroup="b1e2-gr1"
PreName="B1E2-"

# Public IP VM Bastion Variables
BastionIPName=$PreName"VM-Bastion-IP"

# Label Public IP VM Bastion Variables
LabelBastionIPName="esan-preproduction-bastion"

# Label Public IP VM Bastion Update
echo "Label Public IP VM Bastion Update"
az network public-ip update \
 --resource-group $ResourceGroup \
 --name $BastionIPName \
 --dns-name $LabelBastionIPName \
 --allocation-method Static