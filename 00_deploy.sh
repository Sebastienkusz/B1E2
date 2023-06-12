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

# Network Interface Card Variables
Nic=$PreName"Nic"

# Public IP VM Bastion Variables
BastionIPName=$PreName"VM-Bastion-IP"

# Public IP VM Application Variables
AppliIPName=$PreName"VM-Appli-IP"

# Label Public IP VM Bastion Variables
LabelBastionIPName="esan-preproduction-bastion"

# Label Public IP VM Application Variables
LabelAppliIPName="esan-preproduction-nextcloud"

# Network deployment
./01_network.sh

# SQL
./02_bdd.sh

# VM
./03_vm.sh

# Monitoring
