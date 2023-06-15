#!/bin/bash

Admin="nabila"
Usertwo="sebastien"
Userthree="arnaud"

sudo adduser --gecos '' --disabled-password $Usertwo
Groupes=$(groups $Admin | sed "s/"$Admin" : //" | sed "s/"$Admin" //" | sed "s/ /,/g")
sudo usermod -a -G $Groupes $Usertwo
KeyVarTmp="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmGVjetY9Ohwzfx6hDCs+eXMVnjYZdSW5Lhq5mMzbm9OMI+xM96RINmhJs6VagtuksAfkTnoPqvlXXjCXrzCxgd1mUzJQpslJTQh7cNoLrRsqt5w4e8mZ7Q96boibU9e9y8gIhGQTAkFj9T373kyvP33CJsX4IiaYELkHNyqcovcmzZKXzUj304yoAlJ5zYDkuuvSNO19+eiahd3wVTQooPWtmppW0sue5tX7x7CzVqTdkCyweAgy9/2NJqY83/wOeZHbvk21ubJ71f4jNorr91XCpbKzTA2KY532BTdout3RtEzIfXUFll2EJlECoTH1aeDisHxU2a3VfvfoHhf17RwN8WArVPfIfwFpg5D52Df1qb+WDlh/3EMFmi5y2fxgQlqeZ0ErB49Xh9W3E9OEFBrNwtC5aZUSBsC6NJuetPzg43C1Lhzrg9aVXBdPE9tze1ufI0Jyp//xcQGHlsXUx3IaDY8vTrs9Ce7rpsUrkqfGE9lArc3aE+fltvno0UlFzy6jLBxBXdPlzYHkckCNYdQNn/TdXMjYeFWPK5jxGRrQyGmc3QRL61E0mM51YfkuVX/fyx4DANa/AvyqYoIAjI4DhjXYQLyTUznCMLixEf1Sb4wS7IbReXP4b9XF5bia/zx3Vw8yO5bBq3mMzNl9IUowqDpYB1cDNXFM5hD+NLw== kusz.sebastien@gmail.com"
sudo mkdir "/home/"$Usertwo"/.ssh"
sudo echo $KeyVarTmp >> "/home/"$Usertwo"/.ssh/authorized_keys"
sudo su <<EOF
chmod 640 /home/$Usertwo/.ssh/authorized_keys
chmod 700 /home/$Usertwo/.ssh/
chown -R $Usertwo:$Usertwo /home/$Usertwo/.ssh/
echo \""$Usertwo" ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers
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