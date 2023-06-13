#!bin/bash


################## NSG ##################

   #nsg Vm Nextcloud

     
    az network nsg create \
    --resource-group $ResourceGroup \
    --name "myNetworkSecurityGroup"

    az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name "myNetworkSecurityGroup" \
    --name "myNetworkSecurityGroupRuleSSH" \
    --protocol tcp \
    --priority 1000 \
    --destination-port-range 22 \
    --access allow

    az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name "myNetworkSecurityGroup" \
    --name "myNetworkSecurityGroupRuleWeb" \
    --protocol tcp \
    --priority 1001 \
    --destination-port-range 80 \
    --access allow /

    az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name "myNetworkSecurityGroup" \
    --name "myNetworkSecurityGroupRuleWeb" \
    --protocol tcp \
    --priority 1001 \
    --destination-port-range 443 \
    --access allow /

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
vmname="Bastion"
username="nabila"

#Création du Bastion 
az vm create \
    --resource-group $ResourceGroup\
    --name $vmname \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username $username \
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
    --name NextcloudVM \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username nabila \
    --vnet-name $VNet \
    --subnet testauto-subnet \
    --nsg testnsg1 \
    --private-ip-address $AppliVMIPprivate \
    --nsg $NsgAppliName \
    --public-ip-address $AppliIPName \
    --custom-data user_data/configNextcloudVM.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub

#Création d'un disque, avec chiffrement géré par la plateforme Azure
az disk create \
    --resource-group $ResourceGroup\
    --name MyDisk \
    --size-gb 1024 \
    --sku StandardSSD_LRS \
    --encryption-type EncryptionAtRestWithPlatformKey

#Attache disque sur la VM
az vm disk attach \
    --resource-group $ResourceGroup\
    --vm-name NextcloudVM \
    --name MyDisk \

#Lancement du montage du disque
az vm run-command invoke \
    --resource-group $ResourceGroup \
    -n NextcloudVM \
    --command-id RunShellScript \
    --scripts @user_data/mountDisk.sh 

#Lancement de la configuration de la base de données
az vm run-command invoke \
    --resource-group $ResourceGroup\
    -n NextcloudVM \
    --command-id RunShellScript \
    --scripts @user_data/configSQL.sh 