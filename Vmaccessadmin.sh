  #!bin/bash
  
  az vm create \
  --resource-group Arnaud_G \
  --name VM1 \
  --image ubuntu2204 \
  --vnet-name VNet \
  --admin-username adminshepard \
  --ssh-key-value ~/.ssh/id_rsa.pub