#!/bin/bash
# installation wget
apt-get install -y wget
# installation ca-certificates 
apt-get install -y  ca-certificates 
#update-ca-trust force-enable 
cp /ca.crt /usr/local/share/ca-certificates/
# ajout du certificat de nexus
update-ca-certificates

# ajout du hostname nexus au fichiers hosts
echo "192.168.17.133 nexushost.localdomain" >> /etc/hosts
echo "end of script"
/bin/bash

