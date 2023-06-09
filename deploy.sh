  #!bin/bash

 #deploiement vnet
  az network vnet create \
  --name "VNet" \
  --resource-group "Arnaud_G" \
  --address-prefix "10.0.0.0/16" \
  --subnet-name "default" \
  --subnet-prefixes "10.0.0.0/24"
  
 #deploiement vmbastion
  az vm create \
  --resource-group "Arnaud_G" \
  --name "VMbastion" \
  --image "ubuntu2204" \
  --vnet-name "VNet" \
  --subnet "default" \
  --admin-username "adminshepard" \
  --ssh-key-value "~/.ssh/id_rsa.pub"

 #deploiement vmnextcloud
  az vm create \
  --resource-group Arnaud_G \
  --name VMnextcloud \
  --image ubuntu2204 \
  --vnet-name VNet \
  --subnet "default" \
  --admin-username adminshepard \
  --ssh-key-value ~/.ssh/id_rsa.pub

 #deploiement d'un disque detaché sur Azure pour les datas des users Nextcloud
  az disk create \
    --name "W-B1E2-VM-Data-Disk" \
    --resource-group "Arnaud_G" \
    --encryption-type "EncryptionAtRestWithPlatformKey" \
    --size-gb "64" \
    --sku "StandardSSD_LRS" \
    --zone "3" \

#rattachement du disque à la Vmnextcloud

az vm disk attach \
  --vm-name "VMnextcloud" \
  --resource-group "Arnaud_G" \
  --name "W-B1E2-VM-Data-Disk" \

#montage du disque



#creation de la BDD Azure MYSQL

#creation du ddns





