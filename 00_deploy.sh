#!/bin/bash

# Variables
# Resource Group
export ResourceGroup="b1e2-gr1"
export Location="westeurope"
export Zone="3"
export PreName="B1E2-"

# Virtual Network
export VNet=$PreName"Network"
export AdresseStart="192.168.0.0"
export NetworkRange="/16"

# Subnet
export Subnet=$PreName"Subnet-Nextcloud"
export SubnetRange="/29"

# Network Interface Card Variables
export Nic=$PreName"Nic"

# Public IP VM Bastion Variables
export BastionIPName=$PreName"VM-Bastion-IP"

# Public IP VM Application Variables
export AppliIPName=$PreName"VM-Appli-IP"

# Label Public IP VM Bastion Variables
export LabelBastionIPName="esan-preproduction-bastion"

# Label Public IP VM Application Variables
export LabelAppliIPName="esan-preproduction-nextcloud"

#Noms des NSG
export NsgAppliName="nsgNextcloud"
export NsgBastionName="nsgBastion"

# Network deployment
./01_network.sh

# SQL
./02_bdd.sh

# VM
./03_virtMachine.sh

# Monitoring