#!/bin/bash

#Create log-analytics workspace, with 1 year log retention
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$WorkSpaceName']" -o tsv) != "" ]] 
then
    echo "The Log Monitoring Workspace already exists."
else
    echo "Creating Log Monitoring Workspace "
    az monitor log-analytics workspace create \
      -g $ResourceGroup \
      -n $WorkSpaceName \
      --retention-time 365 
fi

#Testing if the deployment was successful
if [[ $(az resource list -g $ResourceGroup --query "[?name == '$WorkSpaceName']" -o tsv) == "" ]]  
then
    echo "ERROR : The Log Monitoring Workspace deployment failed. Starting rollback process." 
    az vm delete -g $ResourceGroup -n $NextcloudVMName --yes
    az vm delete -g $ResourceGroup -n $BastionVMName --yes
    az monitor log-analytics workspace delete -g $ResourceGroup -n $WorkSpaceName --yes
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
    echo "SUCCESS : The Log Monitoring Workspace has been deployed."
fi

#Get all variables needed to configure the monitoring process
NextcloudVMid=$(az vm show --name $NextcloudVMName --resource-group $ResourceGroup --query id --output tsv)
BastionVMid=$(az vm show --name $BastionVMName --resource-group $ResourceGroup --query id --output tsv)
WorkspaceID=$(az monitor log-analytics workspace show --resource-group $ResourceGroup --workspace-name $WorkSpaceName --query id -o tsv)
ResourceGroupID=$(az group show -n $ResourceGroup --query id --output tsv)
#endpointID=$(az monitor private-link-scope show --resource-group $ResourceGroup --workspace-name $WorkSpaceName --query id --output tsv)

#Enabling System-assigned managed identity on VMs. Necessary for access token management.
az vm identity assign \
  -g $ResourceGroup \
  --name $NextcloudVMName

az vm identity assign \
  -g $ResourceGroup \
  --name $BastionVMName

#Association of the DCR with VMs
az monitor data-collection rule association create \
  --name $DataCollectionRuleAssociationName \
  --rule-id $ResourceGroupID/providers/Microsoft.Insights/dataCollectionRules/$DataCollectionRuleName \
  --resource $NextcloudVMid


az monitor data-collection rule association create \
  --name $DataCollectionRuleAssociationName \
  --rule-id $ResourceGroupID/providers/Microsoft.Insights/dataCollectionRules/$DataCollectionRuleName \
  --resource $BastionVMid

#Add a microsoft extension to VMs, to handle the monitoring agent
az vm extension set \
  --resource-group $ResourceGroup \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --ids $NextcloudVMid \
  --enable-auto-upgrade

az vm extension set \
  --resource-group $ResourceGroup \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --ids $BastionVMid  \
  --enable-auto-upgrade


#Configure the syslog deamon on VMs, to forward syslog data to the Log Analytic Workspace
az vm run-command invoke \
    --resource-group $ResourceGroup \
    -n $NextcloudVMName  \
    --command-id RunShellScript \
    --scripts "sudo wget -O Forwarder_AMA_installer.py https://raw.githubusercontent.com/Azure/Azure-Sentinel/master/DataConnectors/Syslog/Forwarder_AMA_installer.py&&sudo python3 Forwarder_AMA_installer.py"


az vm run-command invoke \
    --resource-group $ResourceGroup \
    -n $BastionVMName  \
    --command-id RunShellScript \
    --scripts "sudo wget -O Forwarder_AMA_installer.py https://raw.githubusercontent.com/Azure/Azure-Sentinel/master/DataConnectors/Syslog/Forwarder_AMA_installer.py&&sudo python3 Forwarder_AMA_installer.py"


####The code below can be used to deploy the OMS agent on Linux VMs. OMS agent will be deprecated by August 2024.
####To use it, you will need to downgrade to UbuntuLTS (change variable in 00_deploy.sh) and downgrade the Nextcloud version to 14, with PHP 7 in the configNextcloudVM file.

#Fetch workspace id and key -- will be used to install the agent on VMs
# myWorkspaceId=$(az monitor log-analytics workspace show --resource-group $ResourceGroup --workspace-name $WorkSpaceName --query customerId -o tsv)
# myWorkspaceKey=$(az monitor log-analytics workspace get-shared-keys --resource-group $ResourceGroup --workspace-name $WorkSpaceName --query primarySharedKey -o tsv)

#Add OMSextension to Nextcloud VM
# az vm extension set \
#   --resource-group $ResourceGroup \
#   --name OmsAgentForLinux \
#   --publisher Microsoft.EnterpriseCloud.Monitoring \
#   --vm-name $NextcloudVMName \
#   --enable-auto-upgrade true

#Add OMSextension to Bastion VM
# az vm extension set \
#   --resource-group $ResourceGroup \
#   --name OmsAgentForLinux \
#   --publisher Microsoft.EnterpriseCloud.Monitoring\
#   --vm-name $BastionVMName \
#   --enable-auto-upgrade true

#Agent activation on Nextcloud VM
# az vm run-command invoke \
#     --resource-group $ResourceGroup \
#     -n $NextcloudVMName  \
#     --command-id RunShellScript \
#     --scripts "sudo wget https://raw.githubusercontent.com/Microsoft/OMS-Agent-for-Linux/master/installer/scripts/onboard_agent.sh && sh onboard_agent.sh -w $myWorkspaceId -s $myWorkspaceKey -d opinsights.azure.com"

#Agent activation on Bastion VM
# az vm run-command invoke \
#     --resource-group $ResourceGroup \
#     -n $BastionVMName \
#     --command-id RunShellScript \
#     --scripts "sudo wget https://raw.githubusercontent.com/Microsoft/OMS-Agent-for-Linux/master/installer/scripts/onboard_agent.sh && sh onboard_agent.sh -w $myWorkspaceId -s $myWorkspaceKey -d opinsights.azure.com"


