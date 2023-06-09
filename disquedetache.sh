#!bin/bash

#deploiement d'un disque detaché sur Azure

az disk create \
    --name "W-B1E2-VM-Data-Disk" \
    --resource-group "Arnaud_G" \
    --encryption-type "EncryptionAtRestWithPlatformKey" \
    --size-gb "64" \
    --sku "StandardSSD_LRS" \
    --zone "3" \

 #creation de la Vm

    az vm create \
  --resource-group "Arnaud_G" \
  --name "myVMtest" \
  --image UbuntuLTS \
  --size "Standard_DS2_v2" \
  --admin-username azureuser \
  --generate-ssh-keys \
  --data-disk-sizes-gb 128 128

  #attach du disque

  az vm disk attach \
    --resource-group "Arnaud_G" \
    --vm-name "myVMtest" \
    --name myDataDisk \
    --size-gb 128 \
    --sku Premium_LRS \
    --new