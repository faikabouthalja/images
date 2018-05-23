#!/bin/bash
# installation wget
yum install -y wget
# installation ca-certificates 
yum install -y  ca-certificates 
update-ca-trust force-enable 
cp /ca.crt /etc/pki/ca-trust/source/anchors/ 
# ajout du certificat de nexus
update-ca-trust extract

# ajout du hostname nexus au fichiers hosts
echo "192.168.17.133 nexushost.localdomain" >> /etc/hosts
echo "end of script"
/bin/bash

