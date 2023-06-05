#!/bin/bash

vmname="Bastion"
username="nabila"
resourcegroup="Nabila_R"

#Création du Bastion 
az vm create \
    --resource-group $resourcegroup \
    --name $vmname \
    --image Ubuntu2204\
    --public-ip-sku Standard \
    --admin-username $username \
    --vnet-name testauto-Vnet \
    --subnet testauto-subnet \
    --nsg testnsg \
    --custom-data configBastion.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub

#az vm open-port \
    #--port 10022 \
    #--resource-group $resourcegroup \
    #--name $vmname