#!/bin/bash

# Variables
# Resource Group
export ResourceGroup="Nabila_R"
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

# Public label IP VM Bastion Variables
export LabelBastionIPName=$Client$PreName"bastionnab"

# Public label IP VM Application Variables
export LabelAppliIPName=$Client$PreName"nextcloudnab"

#Noms des NSG
export NsgAppliName=$PreName"nsg-nextcloud"
export NsgBastionName=$PreName"nsg-bastion"

#Filtering nsg rules
export NsgBastionRuleIPFilter="82.126.234.200"
export NsgBastionRuleSshPort="10022"


#Resources names
export BastionVMName=$PreName"vm-bastion"
export NextcloudVMName=$PreName"vm-nextcloud"
export BDDName=$PreName"bdd-sqlnab"
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
export WorkSpaceName=$Client$PreName"workspacenab"
export DataCollectionRuleName=$Client$PreName"datacollectionrule"
export DataCollectionRuleAssociationName=$Client$PreName"datacollectionruleassociation"
export EndPointName=$Client$PreName"endpoint"

#Default user
export Username="nabila"
export SshPublicKeyFile="nab_rsa.pub"

export killProcess=0


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

# BDD
export BDDUrlName=$PreName"bdd-sql"
export BddName="nextcloud"


# Network deployment
./01_network.sh 

killProcess=$?
if [ $killProcess -eq 1 ]; then
    exit
fi

# SQL
#./02_bdd.sh

killProcess=$?
if [ $killProcess -eq 1 ]; then
    exit
fi

#VM
./03_virtMachine.sh

killProcess=$?
if [ $killProcess -eq 1 ]; then
    exit
fi

# Monitoring
./04_monitoring.sh

killProcess=$?
if [ $killProcess -eq 1 ]; then
    exit
fi

#BackupService
# ./05_backup.sh

killProcess=$?
if [ $killProcess -eq 1 ]; then
    exit
fi

echo "---------------------------------------------------------------------------------------------------------------"
echo "Aller sur votre navigateur web et connectez-vous à l'adresse suivante :"
az network public-ip show --resource-group $ResourceGroup --name $AppliIPName --query "{address: ipAddress}"

echo "créer le compte administrateur de nextcloud avant de continuer"

echo "Voir les informations sur le Readme"

echo "nom de la bdd : " $BddName
echo "adresse du serveur : " $BDDUrlName.mysql.database.azure.com

echo "Taper le mot entre crochet pour continuer [Nextcloud]"
read mot
while
[ "$mot" = "Nextcloud" ]
do
echo "Taper le mot entre crochet pour continuer [Nextcloud]"
read mot
done

#Ajout des utilisateurs admins à la VM Nextcloud
az vm run-command invoke \
    --resource-group $ResourceGroup \
    --name $NextcloudVMName \
    --command-id RunShellScript \
    --scripts @./user_data/Post_install.sh


az vm run-command invoke --resource-group $ResourceGroup --name $NextcloudVMName --command-id RunShellScript --scripts @./user_data/Post_install.sh


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
