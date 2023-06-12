 #!bin/bash

az network vnet create \

  --name VNet \
  --resource-group Arnaud_G \
  --address-prefix 10.0.0.0/26 \
  --subnet-name default \
  --subnet-prefixes 10.0.0.0/29

  az vm create \
  --resource-group Arnaud_G \
  --name VM1 \
  --image ubuntu-latest \

  