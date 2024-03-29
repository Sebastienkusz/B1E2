#!/bin/bash

# Variables
# Resource Group
export ResourceGroup="b1e2-gr1"
export Location="westeurope"
export Zone="3"
export PreName="preproduction-"
export Client="enas-"

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

# Public label IP VM Bastion Variables
export LabelBastionIPName=$Client$PreName"bastion"

# Public label IP VM Application Variables
export LabelAppliIPName=$Client$PreName"nextcloud"

# NSG name
export NsgAppliName=$PreName"nsg-nextcloud"
export NsgBastionName=$PreName"nsg-bastion"

# Filtering nsg rules
export NsgBastionRuleIPFilter="82.126.234.200"
export NsgBastionRuleSshPort="10022"


#Resources names
## BDD
export SuffixBddUrl=".mysql.database.azure.com"

export AdminSQL="adminsql"
export AdminSQLPassword="dauphinrouge"
export UserSQL="sqluser"
export UserSQLPassword="dauphinvert"
export BddName="nextcloud"
export BddAzName=$PreName"bdd-sql"
export BddUrlName=$PreName"bdd-sql"$SuffixBddUrl
export BackupBDDName=$PreName"backupbdd-sql"

# OS image
export ImageOs="Ubuntu2204"

## Bastion VM
export BastionVMName=$PreName"vm-bastion"
export BastionVMSize="Standard_B2s"
export OSDiskBastion=$PreName"OSDisk-Bastion"
export OSDiskBastionSizeGB="30"
export OSDiskBastionSku="Standard_LRS"
export BastionVMIPprivate="11.0.0.5"

## Nextcloud VM
export NextcloudVMName=$PreName"vm-nextcloud"
export NextcloudVMSize="Standard_D2s_v3"
export NextcloudVMIPprivate="11.0.0.6"
export DiskName=$PreName"disk-nextcloud"
export DataDiskNextcloudSize="1024"

## Other
export BackupVaultName=$PreName"backupvault"

# Monitoring variables
export WorkSpaceName=$Client$PreName"workspace"
export DataCollectionRuleName=$Client$PreName"datacollectionrule"
export DataCollectionRuleAssociationName=$Client$PreName"datacollectionruleassociation"
# export EndPointName=$Client$PreName"endpoint"

# Default user
export Username="nabila"
export SshPublicKeyFile="nab_rsa.pub"

#Variable used to evaluate the error status during the script execution
export endProcess=0

#Help command
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

endProcess=$?
if [ $endProcess -eq 1 ]; then
    exit
fi

# SQL
./02_bdd.sh

endProcess=$?
if [ $endProcess -eq 1 ]; then
    exit
fi

#VM
./03_virtMachine.sh

endProcess=$?
if [ $endProcess -eq 1 ]; then
    exit
fi

# Monitoring
./04_monitoring.sh

endProcess=$?
if [ $endProcess -eq 1 ]; then
    exit
fi

# BackupService
./05_backup.sh


echo "---------------------------------------------------------------------------------------------------------------"
echo " "
echo " Infrastructure déployée "
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
echo " Adresse Internet : https://"$LabelAppliIPName"."$Location".cloudapp.azure.com"
echo "---------------------------------------------------------------------------------------------------------------"
