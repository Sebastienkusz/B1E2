#!bin/bash


################## NSG ##################
# NSG create 
az network nsg create \
--resource-group "b1e2-gr1" \
--name "myNetworkSecurityGroup"

az network nsg rule create \
--resource-group "b1e2-gr1" \
--nsg-name "myNetworkSecurityGroup" \
--name "myNetworkSecurityGroupRuleSSH" \
--protocol tcp \
--priority 1000 \
--destination-port-range 22 \
--access allow

az network nsg rule create \
--resource-group "b1e2-gr1" \
--nsg-name "myNetworkSecurityGroup" \
--name "myNetworkSecurityGroupRuleWeb" \
--protocol tcp \
--priority 1001 \
--destination-port-range 80 \
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
resourcegroup="Nabila_R"
# az network public-ip create \
#     -g Nabila_R \
#     -n MyIp1 \
#     --dns-name mybastion \
#     --allocation-method Static

#Création du Bastion 
az vm create \
    --resource-group $resourcegroup \
    --name $vmname \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username $username \
    --vnet-name testauto-Vnet \
    --subnet testauto-subnet \
    --nsg testnsg \
    --public-ip-address-allocation static \
    --public-ip-address-dns-name mybastion2 \
    --custom-data user_data/configBastion.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub


################## VM Application ##################
#Création de la VM Nextcloud
az vm create \
    --resource-group Nabila_R \
    --name NextcloudVM \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username nabila \
    --vnet-name testauto-Vnet \
    --subnet testauto-subnet \
    --nsg testnsg1 \
    --public-ip-address-allocation static \
    --public-ip-address-dns-name nextcloud01 \
    --custom-data user_data/configNextcloudVM.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub

#Création d'un disque, avec chiffrement géré par la plateforme Azure
az disk create \
    --resource-group Nabila_R \
    --name MyDisk \
    --size-gb 1024 \
    --sku StandardSSD_LRS \
    --encryption-type EncryptionAtRestWithPlatformKey

#Attache disque sur la VM
az vm disk attach \
    --resource-group Nabila_R \
    --vm-name NextcloudVM \
    --name MyDisk \

#Lancement du montage du disque
az vm run-command invoke \
    --resource-group Nabila_R \
    -n NextcloudVM \
    --command-id RunShellScript \
    --scripts @user_data/mountDisk.sh 

#Lancement de la configuration de la base de données
az vm run-command invoke \
    --resource-group Nabila_R \
    -n NextcloudVM \
    --command-id RunShellScript \
    --scripts @user_data/configSQL.sh 