#!/bin/bash

# Variables
# Resource Group
export ResourceGroup="Nabila_R"
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
export LabelBastionIPName="esan-preproduction-bastion01"

# Label Public IP VM Application Variables
export LabelAppliIPName="esan-preproduction-nextcloud01"

#Noms des NSG
export NsgAppliName="nsgNextcloud"
export NsgBastionName="nsgBastion"

#Noms des ressources
export BastionVMName="preproduction-vm-bastion02"
export NextcloudVMName="preproduction-vm-Nextcloud02"
export BDDName="dsi-bdd-sql02"
export DiskName="preproduction-disk-esan"

#Utilisateur
export Username="nabila"
# Network deployment
# ./01_network.sh

# # SQL
# ./02_bdd.sh

# VM
./03_virtMachine.sh

# Monitoring
./04_monitoring.sh