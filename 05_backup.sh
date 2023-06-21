#!/bin/bash

#Create a backup for mysql flexible-server
az mysql flexible-server backup create \
    --backup-name $BackupBDDName \
    --name $BDDName \
    --resource-group $ResourceGroup

#Create Backup Vault
az backup vault create \
    --resource-group $ResourceGroup \
    --name $BackupVaultName \
    --location $Location

##Create a backup protection policy for the Nextcloud VM
az backup protection enable-for-vm \
    --resource-group $ResourceGroup \
    --vault-name $BackupVaultName \
    --vm $NextcloudVMName \
    --policy-name DefaultPolicy

#Starting backup process, without waiting for the default policy to run the job
az backup protection backup-now \
    --resource-group $ResourceGroup \
    --vault-name $BackupVaultName \
    --container-name $NextcloudVMName \
    --item-name $NextcloudVMName \
    --backup-management-type AzureIaaSVM \
    --retain-until 31-12-2024


