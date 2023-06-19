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
export SubnetRange="/26"

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

#Filtering nsg rules
export NsgBastionRuleIPFilter="82.126.234.200"
export NsgBastionRuleSshPort="10022"


#Resources names
export BastionVMName=$PreName"vm-bastion"
export NextcloudVMName=$PreName"vm-nextcloud"
export BDDName=$PreName"bdd-sql"
export BackupBDDName=$PreName"backupbdd-sql"
export BackupVaultName=$PreName"backupvault"
export DiskName=$PreName"disk-nextcloud"

export ImageOs="Ubuntu2204"
export BastionVMSize="Standard_B2s"
export NextcloudVMSize="Standard_D2s_v3"
export OSDiskBastion=$PreName"OSDisk-Bastion"
export OSDiskBastionSizeGB="30"
export OSDiskBastionSku="Standard_LRS"

export DataDiskNextcloudSize="1024"

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
./05_backup.sh


echo "---------------------------------------------------------------------------------------------------------------"
echo " "
echo " Infrastruture déployée "
echo " ---------------------- "
echo " Bastion :"
echo " - fqdn : "$LabelBastionIPName"."$Location".cloudapp.azure.com"
echo " - port ssh : "$NsgBastionRuleSshPort
echo " - adresse ip privée :"$BastionVMIPprivate
echo " - filtrage IP par ssh : Accès uniquement avec l'adresse IP publique "$NsgBastionRuleIPFilter
echo " - nom du premier administrateur : "$Username
echo " "
echo " - exemple de Connexion ssh : ssh "$Username"@"$LabelBastionIPName"."$Location".cloudapp.azure.com -p "$NsgBastionRuleSshPort
echo "   Précisez la clé ssh avec le paramètre -i suivi du chemin et du nom de la clé"
echo "   et utilsez le rebond avec le paramètre -A"
echo " "
echo " VM Nextcloud :"
echo " - adresse ip privée : "$NextcloudVMIPprivate
echo " - exemple de Connexion ssh : ssh "$Username"@"$NextcloudVMIPprivate
echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo " Adresse Internet : "$LabelAppliIPName"."$Location".cloudapp.azure.com"
echo "---------------------------------------------------------------------------------------------------------------"
