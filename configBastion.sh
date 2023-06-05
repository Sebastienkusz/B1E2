#!/bin/bash

sudo apt update && sudo apt upgrade

#parcours du fichier sshd_config pour remplacer #Port 22 par Port 10022
sed -i 's/#Port 22/Port 10022/' /etc/ssh/sshd_config
sudo service sshd restart



