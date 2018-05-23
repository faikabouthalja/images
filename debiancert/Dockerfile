
FROM  nexushost.localdomain:8082/mydebian
# ajout du certificat de nexus
#ADD ca.crt .

RUN . /root/.bashrc; \
    sleep 2; \
# installation wget
    apt-get install -y wget;\
# installation ca-certificates
    apt-get install -y  ca-certificates
#update-ca-trust force-enable
COPY ca.crt /usr/local/share/ca-certificates/
# ajout du certificat de nexus
RUN update-ca-certificates; \
# ajout du hostname nexus au fichiers hosts
    echo "192.168.17.133 nexushost.localdomain" >> /etc/hosts

#ADD script.sh /root/
#RUN chmod a+x /root/script.sh
#execution script
CMD  ["/bin/bash"]
