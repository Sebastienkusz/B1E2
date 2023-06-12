#!/bin/bash


az keyvault create \
    --resource-group Nabila_R\
    --name MyKeyVault080319  \
    --enabled-for-deployment

az keyvault certificate create \
    --vault-name MyKeyVault080319  \
    --name mycert \
    --policy "$(az keyvault certificate get-default-policy)"






