az network vnet create \
    --resource-group "Arnaud_G" \
    --name "myVnet" \
    --address-prefix 192.168.0.0/16 \
    --subnet-name "mySubnet" \
    --subnet-prefix 192.168.1.0/24


az network public-ip create \
    --resource-group "Arnaud_G" \
    --name "myPublicIP" \
    --dns-name "nextcloudazure"

    az network nsg create \
    --resource-group "Arnaud_G" \
    --name "myNetworkSecurityGroup"

    az network nsg rule create \
    --resource-group "Arnaud_G" \
    --nsg-name "myNetworkSecurityGroup" \
    --name "myNetworkSecurityGroupRuleSSH" \
    --protocol tcp \
    --priority 1000 \
    --destination-port-range 22 \
    --access allow

    az network nsg rule create \
    --resource-group "Arnaud_G" \
    --nsg-name "myNetworkSecurityGroup" \
    --name "myNetworkSecurityGroupRuleWeb" \
    --protocol tcp \
    --priority 1001 \
    --destination-port-range 80 \
    --access allow

    #creation d'une carte d'interface reseau virtuel (Network Interface Card)

    az network nic create \
    --resource-group "Arnaud_G" \
    --name "myNic" \
    --vnet-name "myVnet" \
    --subnet "mySubnet" \
    --public-ip-address "myPublicIP" \
    --network-security-group myNetworkSecurityGroup

    #creation Vm avec Nic (et donc ddns nextcloudazure.eastus.cloudapp.azure.com)

    az vm create \
    --resource-group "Arnaud_G" \
    --name "myVMnic" \
    --location eastus \
    --availability-set myAvailabilitySet \
    --nics "myNic" \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys