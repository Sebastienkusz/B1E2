
#creation d'une Vm avec un cloud init
az vm create \
    --resource-group "Arnaud_G" \
    --name myAutomatedVM \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --custom-data cloud-init.txt \
#Ouverture du port 80 pour un accès web
az vm open-port \
    --port 80 \
    --resource-group "Arnaud_G" \
    --name "myAutomatedVM" \