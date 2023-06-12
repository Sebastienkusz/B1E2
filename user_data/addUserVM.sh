az vm extension set -n VMAccessForLinux --publisher Microsoft.OSTCExtensions --version 1.4 \
    --vm-name MyVm --resource-group MyResourceGroup \
    --protected-settings '{"username":"user1", "ssh_key":"ssh_rsa ..."}'