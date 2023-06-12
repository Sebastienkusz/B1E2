   #!bin/bash
 
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