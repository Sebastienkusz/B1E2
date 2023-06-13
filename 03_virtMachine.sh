#!bin/bash


################## NSG ##################
    #nsg VM Bastion
az network nsg create \
    --resource-group $ResourceGroup \
    --name $NsgBastionName

az network nsg rule create \
  --resource-group $ResourceGroup  \
  --nsg-name $NsgBastionName\
  --name SSHrule \
  --protocol tcp \
  --direction inbound \
  --priority 1000 \
  --source-address-prefix 82.126.234.200\
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range 10022 \
  --access allow \
   
   
   #nsg Vm Nextcloud

az network nsg create \
    --resource-group $ResourceGroup \
    --name $NsgAppliName

az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name $NsgAppliName \
    --name "HTTPrule " \
    --direction inbound \
    --priority 1000 \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 80 \
    --access allow \

az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name $NsgAppliName \
    --name "HTTPSrule" \
    --protocol tcp \
    --direction inbound \
    --priority 900 \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 443 \
    --access allow \

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

################## VM Bastion ##################


#Création du Bastion 
az vm create \
    --resource-group $ResourceGroup\
    --name $BastionVMName \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username $Username \
    --vnet-name $VNet \
    --subnet $Subnet \
    --nsg $NsgBastionName \
    --public-ip-address $BastionIPName \
    --custom-data user_data/configBastion.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub


################## VM Application ##################
#Création de la VM Nextcloud
az vm create \
    --resource-group $ResourceGroup\
    --name $NextcloudVMName \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username $Username\
    --vnet-name $VNet \
    --subnet $Subnet  \
    --nsg $NsgAppliName \
    --public-ip-address $AppliIPName \
    --custom-data user_data/configNextcloudVM.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub

#Création d'un disque, avec chiffrement géré par la plateforme Azure
az disk create \
    --resource-group $ResourceGroup\
    --name $DiskName \
    --size-gb 1024 \
    --sku StandardSSD_LRS \
    --encryption-type EncryptionAtRestWithPlatformKey

#Attache disque sur la VM
az vm disk attach \
    --resource-group $ResourceGroup\
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
    --resource-group $ResourceGroup\
    -n $NextcloudVMName\
    --command-id RunShellScript \
    --scripts @user_data/configSQL.sh 