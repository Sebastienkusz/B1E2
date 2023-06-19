#!/bin/bash

# Variables
# Resource Group
export ResourceGroup="Nabila_R"
export Location="westeurope"
export Zone="3"
export PreName="Preproduction-"
export ClientName="esan"

# Virtual Network
export VNet=$PreName"Network-Nextcloud"
export AdresseStart="11.0.0.0"
export NetworkRange="/16"

# Subnet
export Subnet=$PreName"Subnet-Nextcloud"
export SubnetRange="/26"

# Network Interface Card Variables
export Nic=$PreName"Nic-Nextcloud"

# Public IP VM Bastion Variables
export BastionIPName=$PreName"IP-Bastion"

# Public IP VM Application Variables
export AppliIPName=$PreName"IP-Nextcloud"

# Public Label IP VM Bastion Variables
export LabelBastionIPName=$ClientName"-preproduction-bastion01"

# Public Label IP VM Application Variables
export LabelAppliIPName=$ClientName"-preproduction-nextcloudn"

#NSG names
export NsgAppliName=$PreName"Nsg-Nextcloud"
export NsgBastionName=$PreName"Nsg-Bastion"

#Filtering nsg rules
export NsgBastionRuleIPFilter="82.126.234.200"
export NsgBastionRuleSshPort="10022"


#Resources names
export BastionVMName=$PreName"Vm-Bastion"
export NextcloudVMName=$PreName"Vm-Nextcloud"
export BDDName="preproduction-bdd-sql01"
export BackupBDDName="preproduction-backupbdd-sql"
export BackupVaultName=$PreName"BackupVault"
export DiskName=$PreName"Disk-Nextcloud"

export ImageOs="Ubuntu2204"
export BastionVMSize="Standard_B2s"
export NextcloudVMSize="Standard_D2s_v3"

export BastionVMIPprivate="11.0.0.5"
export NextcloudVMIPprivate="11.0.0.6"

#Monitoring variables
export WorkSpaceName="Preproduction-Workspace1-"$ClientName
export DataCollectionRuleName="Preproduction-DataCollectionRule-"$ClientName
export DataCollectionRuleAssociationName=$PreName"DataCollectionRuleAssociation-"$ClientName
export EndPointName=$PreName"EndPoint-"$ClientName

#Default user
export Username="nabila"
export SshPublicKeyFile=nab_rsa.pub

Help() {
    echo "This is a Nextcloud deployment script. It can be deployed with no options or with the following options."
    echo "Execution syntax with no options : ./00_deploy"
    echo "Execution syntax with options : ./00_deploy [-s -n -l]"
    echo "-s    VM application size"
    echo "-n    VM application name"
    echo "-l    resources location"
}
while getopts "hs:n:l:" option; do
     case "${option}" in
        h)
            Help
            exit;;
        s)
            NextcloudVMSize=${OPTARG}
            ;;
        n)
            NextcloudVMName=${OPTARG}
            ;;
        l)
            Location=${OPTARG}
            ;;
        \?) echo "Error: Invalid syntax. Use -h for help"
            exit;;
    esac
done


# Network deployment
./01_network.sh

# SQL
./02_bdd.sh

#VM
./03_virtMachine.sh

# Monitoring
./04_monitoring.sh

#BackupService
# ./05_backup.sh
