#!/bin/bash

# Variables
# Resource Group
export ResourceGroup="b1e2-gr1"
export Location="westeurope"
export Zone="3"
export PreName="Preproduction-"

# Virtual Network
export VNet=$PreName"Network-Nextcloud"
export AdresseStart="192.168.0.0"
export NetworkRange="/16"

# Subnet
export Subnet=$PreName"Subnet-Nextcloud"
export SubnetRange="/29"

# Network Interface Card Variables
export Nic=$PreName"Nic-Nextcloud"

# Public IP VM Bastion Variables
export BastionIPName=$PreName"IP-Bastion"

# Public IP VM Application Variables
export AppliIPName=$PreName"IP-Nextcloud"

# Label Public IP VM Bastion Variables
export LabelBastionIPName="esan-preproduction-bastion"

# Label Public IP VM Application Variables
export LabelAppliIPName="esan-preproduction-nextcloud"

#Noms des NSG
export NsgAppliName=$PreName"Nsg-Nextcloud"
export NsgBastionName=$PreName"Nsg_Bastion"

#Noms des ressources
export BastionVMName=$PreName"Vm-Bastion"
export NextcloudVMName=$PreName"Vm-Nextcloud"
export BDDName=$PreName"Bdd-Sql"
export DiskName=$PreName"Disk-Nextcloud"

#Utilisateur
export Username="sebastien"


# Network deployment
./01_network.sh

# SQL
./02_bdd.sh

# VM
bash 03_virtMachine.sh

# Monitoring