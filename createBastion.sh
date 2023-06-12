#!/bin/bash

vmname="Bastion"
username="nabila"
resourcegroup="Nabila_R"
# az network public-ip create \
#     -g Nabila_R \
#     -n MyIp1 \
#     --dns-name mybastion \
#     --allocation-method Static

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
    --public-ip-address-allocation static \
    --public-ip-address-dns-name mybastion2 \
    --custom-data configBastion.sh \
    --ssh-key-value ~/.ssh/id_rsa.pub




