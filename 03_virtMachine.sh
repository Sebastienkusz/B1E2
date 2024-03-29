#!/bin/bash

################## NSG ##################
# nsg Bastion VM deployment
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$NsgBastionName']" -o tsv) != "" ]] 
then
    echo "The Bastion NSG already exists."
else
    echo "Creating Bastion NSG"
    az network nsg create \
    --resource-group $ResourceGroup \
    --name $NsgBastionName
fi

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
    --access allow

#Syslog data forwarding port
az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name $NsgBastionName \
    --name "Monitor" \
    --direction inbound \
    --priority 1001 \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 514 \
    --access Allow

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$NsgBastionName']" -o tsv) == "" ]]  
then
    echo "ERROR : The Bastion NSG deployment failed. Starting rollback process."
    az network nsg delete -g $ResourceGroup -n $NsgBastionName
    az mysql flexible-server delete -g $ResourceGroup -n $BddAzName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    az network private-dns zone delete --name $BddAzName.private.mysql.database.azure.com --resource-group $ResourceGroup --yes
    exit 1
else
    echo "SUCCESS : The Bastion NSG has been deployed."
fi

# nsg Vm Nextcloud
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$NsgAppliName']" -o tsv) != "" ]]  
then
    echo "The Nextcloud NSG already exists."
else
    echo "Creating Nextcloud NSG"
    az network nsg create \
        --resource-group $ResourceGroup \
        --name $NsgAppliName
fi

#HTTP port rule
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

#HTTPS port rule
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

#Syslog data forwarding port
az network nsg rule create \
    --resource-group $ResourceGroup \
    --nsg-name $NsgAppliName \
    --name "Monitor" \
    --direction inbound \
    --priority 1001 \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 514 \
    --access Allow

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$NsgAppliName']" -o tsv) == "" ]] 
then
    echo "ERROR : The Bastion NSG deployment failed. Starting rollback process."
    az network nsg delete -g $ResourceGroup -n $NsgAppliName
    az network nsg delete -g $ResourceGroup -n $NsgBastionName
    az mysql flexible-server delete -g $ResourceGroup -n $BddAzName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    az network private-dns zone delete --name $BddAzName.private.mysql.database.azure.com --resource-group $ResourceGroup --yes
    exit 1 
else
    echo "SUCCESS : The Nextcloud NSG has been deployed."
fi

################## IP Publics ##################
# Public IP VM Bastion Creation
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$BastionIPName']" -o tsv) != "" ]] 
then
    echo "The Bastion VM public IP already exists."
else
    echo "Creating Bastion VM public IP"
    az network public-ip create \
        --resource-group $ResourceGroup \
        --name $BastionIPName \
        --version IPv4 \
        --sku Standard \
        --zone $Zone
fi

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$BastionIPName']" -o tsv) == "" ]] 
then
    echo "ERROR : The Bastion VM public IP deployment failed. Starting rollback process."
    az network public-ip delete -g $ResourceGroup -n $BastionIPName
    az network nsg delete -g $ResourceGroup -n $NsgAppliName
    az network nsg delete -g $ResourceGroup -n $NsgBastionName
    az mysql flexible-server delete -g $ResourceGroup -n $BddAzName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    az network private-dns zone delete --name $BddAzName.private.mysql.database.azure.com --resource-group $ResourceGroup --yes
    exit 1
else
    echo "SUCCESS : The Bastion VM public IP has been deployed."
fi


# Public IP VM Application Creation
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$AppliIPName']" -o tsv) != "" ]] 
then
    echo "The Nextcloud VM public IP already exists."
else
    echo "Creating Nextcloud VM public IP"
    az network public-ip create \
        --resource-group $ResourceGroup \
        --name $AppliIPName \
        --version IPv4 \
        --sku Standard \
        --zone $Zone
fi

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$AppliIPName']" -o tsv) == "" ]] 
then
    echo "ERROR : The Nextcloud VM public IP deployment failed. Starting rollback process."
    az network nic delete -g $ResourceGroup -n $NextcloudVMName"Nic" --force-deletion
    az network public-ip delete -g $ResourceGroup -n $AppliIPName
    az network nic delete -g $ResourceGroup -n $BastionVMName"Nic"
    az network public-ip delete -g $ResourceGroup -n $BastionIPName
    az network nsg delete -g $ResourceGroup -n $NsgAppliName
    az network nsg delete -g $ResourceGroup -n $NsgBastionName
    az mysql flexible-server delete -g $ResourceGroup -n $BddAzName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    az network private-dns zone delete --name $BddAzName.private.mysql.database.azure.com --resource-group $ResourceGroup --yes
    exit 1
else
    echo "SUCCESS : The Nextcloud VM public IP has been deployed."
fi
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
#Creating Bastion VM 
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$BastionVMName']" -o tsv) != "" ]]
then
    echo "The Bastion VM already exists."
else
    echo "Creating Bastion VM"
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
        --nic-delete-option delete \
        --os-disk-delete-option delete \
        --custom-data user_data/configBastion.sh \
        --ssh-key-value ssh_keys/$SshPublicKeyFile
fi

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$BastionVMName']" -o tsv) == "" ]]
then
    echo "ERROR : The Bastion VM deployment failed. Starting rollback process."
    az vm delete -g $ResourceGroup -n $BastionVMName --yes
    az network public-ip delete -g $ResourceGroup -n $AppliIPName
    az network public-ip delete -g $ResourceGroup -n $BastionIPName
    az network nsg delete -g $ResourceGroup -n $NsgAppliName
    az network nsg delete -g $ResourceGroup -n $NsgBastionName
    az mysql flexible-server delete -g $ResourceGroup -n $BddAzName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    az network private-dns zone delete --name $BddAzName.private.mysql.database.azure.com --resource-group $ResourceGroup --yes
    exit 1  
else
    echo "SUCCESS : The Bastion VM has been deployed."
fi

################## VM Application ##################
#Creating Nextcloud VM
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$NextcloudVMName']" -o tsv) != "" ]] 
then
    echo "The Nextcloud VM already exists."
else
    echo "Creating Nextcloud VM"
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
        --nic-delete-option delete \
        --os-disk-delete-option delete \
        --ssh-key-value ssh_keys/$SshPublicKeyFile
fi

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$NextcloudVMName']" -o tsv) == "" ]] 
then
    echo "ERROR : The Nextcloud VM deployment failed. Starting rollback process."
    az vm delete -g $ResourceGroup -n $NextcloudVMName --yes
    az vm delete -g $ResourceGroup -n $BastionVMName --yes
    az network public-ip delete -g $ResourceGroup -n $AppliIPName
    az network public-ip delete -g $ResourceGroup -n $BastionIPName
    az network nsg delete -g $ResourceGroup -n $NsgAppliName
    az network nsg delete -g $ResourceGroup -n $NsgBastionName
    az mysql flexible-server delete -g $ResourceGroup -n $BddAzName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    az network private-dns zone delete --name $BddAzName.private.mysql.database.azure.com --resource-group $ResourceGroup --yes
    exit 1
else
    echo "SUCCESS : The Nextcloud VM has been deployed."
fi

#Creating encrypted managed disk. The encryption is handled by the Azure platform.
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$DiskName']" -o tsv) != "" ]]  
then
    echo "The Managed Disk already exists."
else
    echo "Creating Managed Disk"
    az disk create \
        --resource-group $ResourceGroup \
        --name $DiskName \
        --size-gb $DataDiskNextcloudSize \
        --sku StandardSSD_LRS \
        --encryption-type EncryptionAtRestWithPlatformKey
fi

#Attaching managed disk on Nextcloud VM
az vm disk attach \
    --resource-group $ResourceGroup \
    --vm-name $NextcloudVMName \
    --name $DiskName \

#Running mount disk script on Nextcloud VM
az vm run-command invoke \
    --resource-group $ResourceGroup \
    -n $NextcloudVMName \
    --command-id RunShellScript \
    --scripts @user_data/mountDisk.sh 

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$DiskName']" -o tsv) == "" ]]  
then
    echo "ERROR : The Managed Disk deployment failed. Starting rollback process."
    az vm delete -g $ResourceGroup -n $NextcloudVMName --yes
    az vm delete -g $ResourceGroup -n $BastionVMName --yes
    az disk delete -g $ResourceGroup -n $DiskName --yes
    az network public-ip delete -g $ResourceGroup -n $AppliIPName
    az network public-ip delete -g $ResourceGroup -n $BastionIPName
    az network nsg delete -g $ResourceGroup -n $NsgAppliName
    az network nsg delete -g $ResourceGroup -n $NsgBastionName
    az mysql flexible-server delete -g $ResourceGroup -n $BddAzName --yes
    az network vnet delete -g $ResourceGroup -n $VNet
    az network private-dns zone delete --name $BddAzName.private.mysql.database.azure.com --resource-group $ResourceGroup --yes
    exit 1
else
    echo "SUCCESS : The Managed Disk has been deployed."
fi

#Running data base configuration script on Nextcloud VM
az vm run-command invoke \
    --resource-group $ResourceGroup \
    --name $NextcloudVMName \
    --command-id RunShellScript \
    --scripts @user_data/configSQL.sh 

#Configuring the Nextcloud installation on the application VM
az vm run-command invoke \
    --resource-group $ResourceGroup \
    --name $NextcloudVMName \
    --command-id RunShellScript \
    --scripts @user_data/configNextcloudVM.sh

#Running add administrator to Bastion VM
az vm run-command invoke \
    --resource-group $ResourceGroup \
    --name $BastionVMName \
    --command-id RunShellScript \
    --scripts @./user_data/addusers.sh

#Running add administrator to Nextcloud VM
az vm run-command invoke \
    --resource-group $ResourceGroup \
    --name $NextcloudVMName \
    --command-id RunShellScript \
    --scripts @./user_data/addusers.sh



