#!/bin/bash

Admin="sebastien"
Usertwo="nabila"
Userthree="arnaud"

sudo adduser --gecos '' --disabled-password $Usertwo
Groupes=$(groups $Admin | sed "s/"$Admin" : //" | sed "s/"$Admin" //" | sed "s/ /,/g")
sudo usermod -a -G $Groupes $Usertwo
KeyVarTmp="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7W0gL4i4EsD4rhhvUM+e/yr56n3FrbjM4ob9rJ+NRiW0lWqRz+Nvb5DH8SlJmZrVo0szN1xZ490WXj4E5mZU9YuddNu1O/Y4rNJBcLvCeQebOLcs5710XOieucK2FG+NfUTXRmgyFBNm4hfWoRwPcjRULAAsSLGo8VkMxCR965jPaz4jVm4qxOBYNYATN48oPyC2Tf6sreHEld4DgNjBGACASjYDH2+AaaCTQWJa0YpCMyZlzC1++hwRKrpgyvqmUISPQoS4rNRjI1Rsc9zJtixBuLLi5qww70RlPBt5vG2mj4rOssgltC/MashrTJes7398pcngIqsGA2VySPDMvpyVyRYIBnjMJY1sS6zKmYIiXJnQPdn/pcj/442BALUgIP45F6V9OwUiX0JT1HZi5NU79YJKtD94okEU6SPsJqoO2IDkNNMI9b5ZGojnvJT373Ho2X+c6g0WzoM+ViJbjXfYc6fOOg7MLalsAkDSNbQ6l2qNnX+RG10RtNl+K4BI8qOtwKuPuq7tWP4gCKaVzbQ4dk2CL5TwQ3AGDKdnbDx0OEmD8o6Vk9aKx643lUc6P4z3KSr7PeWbJqt7dFQpoZzmupQ9zVXRvfR/c7rmE/LD5joh+tgYUIt0ufwkRvZccYM4FzuXFAT4W+TZgd6lpRc2IS2jU+vk4qLWGLs5YzQ== Nextcloud"
sudo mkdir "/home/"$Usertwo"/.ssh"
sudo echo $KeyVarTmp >> "/home/"$Usertwo"/.ssh/authorized_keys"
sudo su <<EOF
chmod 640 /home/$Usertwo/.ssh/authorized_keys
chmod 700 /home/$Usertwo/.ssh/
chown -R $Usertwo:$Usertwo /home/$Usertwo/.ssh/
EOF

sudo adduser --gecos '' --disabled-password $Userthree
Groupes=$(groups $Admin | sed "s/"$Admin" : //" | sed "s/"$Admin" //" | sed "s/ /,/g")
sudo usermod -a -G $Groupes $Userthree
KeyVarTmp="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOYrX4h60z1aXIbt+9cKcuTdP+j1itrJurEDLBvM6jL9P/oewtCGYZXKfkTe8HDJlqM2Mp28PXISP0fwl0CgPsdrSNWhOxoyGS0tyYSbkujhu1wGW5V9iT8uvAYQSHHKdu53J058SHzSHvjKip7Bz+sthyeL8KzSFGv06Xw2FvNN2IR/68l/fgwMISYfQuaEXiOUQE/K6sT+V4iBcI2owPf5okxqSVEgPH5OTaAwI+RdCiqH8PQTog7+eHCVOaCgHa+4UAoKokkYz7CefKogDUF8EGmmVZzYz6/HJTgxynuQoCHHj2DycMvUXrxZREvUwkECC0Cf9l8temBza2uc3XVaSKSuu0FLKElwXMf8CKMzjTXj7Pkxm4mAkAQvLIUQ5ZdrtV7HeLbgbcheD7uMW/v/tHOp3ZHuI1rY74Qu3tqiaOUKLc2GPKOGi4ooGH4OUygJBvcskff05jUdFDWP4nCcTvMswit4ZGFi/soSIVJdLWlzqISems5k5tBP9ii86yaHP3HQab9IK81ztabXW9IbYL52a8auhDQr5Mr0tGynppjeKFq52XAGbGVJP28NTpL6PazwbitFSXg17lkxJeEUX9xm7iYbWBNLdBncE6Y76aZd++ltIScUqlryBJK14y1U6S+iLck7/G3g1lvfgzu2NkKNvl1UtKb43WSjX3cw== arnaud.gutierrez@gmail.com"
sudo mkdir "/home/"$Userthree"/.ssh"
sudo echo $KeyVarTmp >> "/home/"$Userthree"/.ssh/authorized_keys"
sudo su <<EOF
chmod 640 /home/$Userthree/.ssh/authorized_keys
chmod 700 /home/$Userthree/.ssh/
chown -R $Userthree:$Userthree /home/$Userthree/.ssh/
EOF