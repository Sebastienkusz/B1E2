#!/bin/bash

az vm create \
    --resource-group Nabila_R \
    --name NextcloudVM \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username nabila \
    --vnet-name testauto-Vnet \
    --subnet testauto-subnet \
    --nsg testnsg1 \
    --custom-data configNextcloudVM.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub