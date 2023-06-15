#!/bin/bash

# Variables
# Resource Group
export ResourceGroup="b1e2-gr1"
export Location="westeurope"
export Zone="3"
export PreName="preproduction-"
export Client="esan-"

# Virtual Network
export VNet=$PreName"network-nextcloud"
export AdresseStart="11.0.0.0"
export NetworkRange="/16"

# Subnet
export Subnet=$PreName"subnet-nextcloud"
export SubnetRange="/29"

# Network Interface Card Variables
export Nic=$PreName"nic-nextcloud"

# Public IP VM Bastion Variables
export BastionIPName=$PreName"ip-bastion"

# Public IP VM Application Variables
export AppliIPName=$PreName"ip-nextcloud"

# Label Public IP VM Bastion Variables
export LabelBastionIPName=$Client$PreName"bastion"

# Label Public IP VM Application Variables
export LabelAppliIPName=$Client$PreName"nextcloud"

#Noms des NSG
export NsgAppliName=$PreName"nsg-nextcloud"
export NsgBastionName=$PreName"nsg-bastion"

export NsgBastionRuleIPFilter="82.126.234.200"
export NsgBastionRuleSshPort="10022"


#Noms des ressources
export BastionVMName=$PreName"vm-bastion"
export NextcloudVMName=$PreName"vm-nextcloud"
export BDDName=$PreName"bdd-sql"
export DiskName=$PreName"disk-nextcloud"

export ImageOs="UbuntuLTS"
export BastionVMSize="Standard_B2s"
export NextcloudVMSize="Standard_D2s_v3"

export BastionVMIPprivate="11.0.0.5"
export NextcloudVMIPprivate="11.0.0.6"

#Utilisateur
export Username="nabila"


# Network deployment
./01_network.sh

# SQL
./02_bdd.sh

# VM
./03_virtMachine.sh

# Monitoring
#./04_monitoring.sh