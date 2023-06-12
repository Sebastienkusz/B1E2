#!/bin/bash

# clientip=$(curl ifconfig.me) 
# nextcloudip=$(az vm show -d -g Nabila_R -n NextcloudVM --query privateIps -o tsv)

az network vnet subnet update \
    --resource-group Nabila_R \
    --name testauto-subnet \
    --vnet-name testauto-Vnet \
    --delegations Microsoft.Sql/managedInstances


az mysql flexible-server create \
    --resource-group Nabila_R \
    -n testbdd01 \
    --location westeurope \
    --vnet testauto-Vnet \
    --version 8.0.21\
    -u nabila \
    -p password0606! \
    --yes

#Récupérer l'IP publique client et l'ajouter aux règles firewall du serveur BDD (pour les tâches d'administration)
#clientip=$(curl ifconfig.me)  
#az mysql server firewall-rule create -\
    #--resource-group Nabila_R\
    #--server nabSQLserver0803 \
    #--name clientIP \
    #--start-ip-address $clientip\
    #--end-ip-address $clientip

# az mysql server firewall-rule create \
#     --resource-group Nabila_R\
#     --server testbdd01 \
#     --name NextcloudIP \
#     --start-ip-address $nextcloudip\
#     --end-ip-address $nextcloudip

az mysql flexible-server db create \
    --resource-group Nabila_R \
    --server-name testbdd01  \
    --database-name nextcloud 



# az mysql flexible-server execute -n nabSQLserver080301 -u nabila -p "password0606!" -d Nextcloud --querytext "USE nextcloud;"
# az mysql flexible-server execute -n nabSQLserver080301 -u nabila -p "password0606!" -d Nextcloud --querytext "CREATE USER 'sqluser'@' %' IDENTIFIED BY 'password';"
# az mysql flexible-server execute -n nabSQLserver080301 -u nabila -p "password0606!" -d Nextcloud --querytext "GRANT ALL PRIVILEGES ON nextcloud.* TO 'sqluser'@'%';"
# az mysql flexible-server execute -n nabSQLserver080301 -u nabila -p "password0606!" -d Nextcloud --querytext "FLUSH PRIVILEGES;"

#az sql flexible-server create \
    #-l westeurope \
    #-g Nabila_R \
    #-n nabSQLserver0803 \
    #-u nabila \
    #-p password0606! \
    #--enable-public-network false

#az sql db create \
#    --resource-group Nabila_R \
 #   --server nabSQLserver0803 \
  #  --name Nextcloud \
   # --catalog-collation SQL_Latin1_General_CP1_CI_AS 

#az sql server ad-admin create \
    #--resource-group Nabila_R \
    #--server-name nabSQLserver0803 \
    #--display-name ADMIN \ 
    #--object-id $azureaduser

#id=$(az sql server list \
    #--resource-group CreateSQLEndpointTutorial-rg \
    #--query '[].[id]' \
   # --output tsv)

#az network private-endpoint create \
    #--name myPrivateEndpoint \
    #--resource-group Nabila_R \
    #--vnet-name testauto-Vnet \
    #--subnet testauto-subnet \
    #--private-connection-resource-id $id \
    #--group-ids sqlServer \
    #--connection-name myConnection