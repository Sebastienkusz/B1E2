  #!bin/bash

#deploiement vnet
  az network vnet create \
  --name "VNet" \
  --resource-group "Arnaud_G" \
  --address-prefix "10.0.0.0/26" \
  --subnet-name "default" \
  --subnet-prefixes "10.0.0.0/29"
  
 #deploiement vmbastion 
  az vm create \
  --resource-group "Arnaud_G" \
  --name "VMbastion" \
  --image "ubuntu2204" \
  --vnet-name "VNet" \
  --admin-username "adminshepard" \
  --ssh-key-value "~/.ssh/id_rsa.pub"

 #deploiement vmnextcloud
  az vm create \
  --resource-group Arnaud_G \
  --name VMnextcloud \
  --image ubuntu2204 \
  --vnet-name VNet \
  --admin-username adminshepard \
  --ssh-key-value ~/.ssh/id_rsa.pub





