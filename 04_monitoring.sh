#!/bin/bash

# az monitor account create\
#  --azure-monitor-workspace-name Monitor \
#  --resource-group $ResourceGroup \
#  --location $Location

az monitor log-analytics workspace create \
    -g Nabila_R \
    -n MyWorkspace \
    --retention-time 60 \


# myWorkspaceId=$(az monitor log-analytics workspace show --resource-group Nabila_R --workspace-name MyWorkspace --query customerId -o tsv)
# myWorkspaceKey=$(az monitor log-analytics workspace get-shared-keys --resource-group Nabila_R --workspace-name MyWorkspace --query primarySharedKey -o tsv)

# az vm extension set \
#   --resource-group Nabila_R\
#   --vm-name preproduction-vm-Nextcloud02 \
#   --name OmsAgentForLinux \
#   --publisher Microsoft.EnterpriseCloud.Monitoring \
#   --protected-settings {\"workspaceKey\":\""$myWorkspaceKey"\"}\
#   --settings {\"workspaceId\":\""$myWorkspaceId"\"} \
#   --version 1.14.23
#VMid = $(az vm show --name preproduction-vm-Nextcloud02 --resource-group $resourceGroup --query 'networkProfile.networkInterfaces[].id' --output tsv)

az vm extension set \
  --resource-group Nabila_R \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --vm-name preproduction-vm-Nextcloud02 \
  --version 1.26.2 \
  --enable-auto-upgrade true