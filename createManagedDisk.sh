#!/bin/bash

#Création d'un disque, avec chiffrement géré par la plateforme Azure
az disk create \
    --resource-group Nabila_R \
    --name MyDisk \
    --size-gb 1024 \
    --sku StandardSSD_LRS \
    --encryption-type EncryptionAtRestWithPlatformKey 

