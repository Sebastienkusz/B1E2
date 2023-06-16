#!/bin/bash

################## NSG ##################
# nsg VM Bastion
az network nsg create \
    --resource-group $ResourceGroup \
    --name $NsgBastionName

az network nsg rule create \
    --resource-group $ResourceGroup  \
    --nsg-name $NsgBastionName \
    --name SSHrule \
    --protocol Tcp \
    --direction Inbound \
    --priority 1000 \
    --source-address-prefix $NsgBastionRuleIPFilter \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range $NsgBastionRuleSshPort \
    --access Allow
   
# nsg Vm Nextcloud
az network nsg create \
    --resource-group $ResourceGroup \
    --name $NsgAppliName

az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name $NsgAppliName \
    --name HTTPrule \
    --protocol Tcp \
    --direction inbound \
    --priority 1000 \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 80 \
    --access Allow

az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name $NsgAppliName \
    --name HTTPSrule \
    --protocol Tcp \
    --direction Inbound \
    --priority 900 \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 443 \
    --access Allow

az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name $NsgAppliName \
    --name Monitor \
    --protocol Tcp \
    --direction Inbound \
    --priority 1001 \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 514 \
    --access Allow


################## IP Publics ##################
# Public IP VM Bastion Creation
az network public-ip create \
   --resource-group $ResourceGroup \
   --name $BastionIPName \
   --version IPv4 \
   --sku Standard \
   --zone $Zone

# Public IP VM Application Creation
az network public-ip create \
   --resource-group $ResourceGroup \
   --name $AppliIPName \
   --version IPv4 \
   --sku Standard \
   --zone $Zone

################## Record DNS ##################
# Label Public IP VM Bastion Update
az network public-ip update \
 --resource-group $ResourceGroup \
 --name $BastionIPName \
 --dns-name $LabelBastionIPName \
 --allocation-method Static

 # Label Public IP VM Application Update
az network public-ip update \
 --resource-group $ResourceGroup \
 --name $AppliIPName \
 --dns-name $LabelAppliIPName \
 --allocation-method Static

################# VM Bastion ##################

#Création du Bastion 
az vm create \
    --resource-group $ResourceGroup \
    --name $BastionVMName \
    --location $Location \
    --size $BastionVMSize \
    --image $ImageOs \
    --public-ip-sku Standard \
    --admin-username $Username \
    --vnet-name $VNet \
    --subnet $Subnet \
    --nsg $NsgBastionName \
    --public-ip-address $BastionIPName \
    --private-ip-address $BastionVMIPprivate \
    --custom-data user_data/configBastion.sh \
    --ssh-key-value ssh_keys/auto_rsa.pub

################## VM Application ##################
#Création de la VM Nextcloud
az vm create \
    --resource-group $ResourceGroup \
    --name $NextcloudVMName \
    --location $Location \
    --size $NextcloudVMSize \
    --image $ImageOs \
    --public-ip-sku Standard \
    --admin-username $Username \
    --vnet-name $VNet \
    --subnet $Subnet \
    --nsg $NsgAppliName \
    --public-ip-address $AppliIPName \
    --private-ip-address $NextcloudVMIPprivate \
    --custom-data user_data/configNextcloudVM.sh \
    --ssh-key-value ssh_keys/auto_rsa.pub

#Création d'un disque, avec chiffrement géré par la plateforme Azure
az disk create \
    --resource-group $ResourceGroup \
    --name $DiskName \
    --size-gb 1024 \
    --sku StandardSSD_LRS \
    --encryption-type EncryptionAtRestWithPlatformKey

# az vm run-command invoke \
#     --resource-group $ResourceGroup \
#     -n $NextcloudVMName \
#     --command-id RunShellScript \
#     --scripts @user_data/configNextcloudVM.sh 

#Attache disque sur la VM
az vm disk attach \
    --resource-group $ResourceGroup \
    --vm-name $NextcloudVMName \
    --name $DiskName \

#Lancement du montage du disque
az vm run-command invoke \
    --resource-group $ResourceGroup \
    -n $NextcloudVMName \
    --command-id RunShellScript \
    --scripts @user_data/mountDisk.sh 

#Lancement de la configuration de la base de données
az vm run-command invoke \
    --resource-group $ResourceGroup \
    -n $NextcloudVMName \
    --command-id RunShellScript \
    --scripts @user_data/configSQL.sh 

#Ajout des utilisateurs admins à la VM Bastion
az vm run-command invoke \
    --resource-group $ResourceGroup \
    -n $BastionVMName \
    --command-id RunShellScript \
    --scripts @./user_data/addusers.sh

#Ajout des utilisateurs admins à la VM Nextcloud
az vm run-command invoke \
    --resource-group $ResourceGroup \
    -n $NextcloudVMName \
    --command-id RunShellScript \
    --scripts @./user_data/addusers.sh