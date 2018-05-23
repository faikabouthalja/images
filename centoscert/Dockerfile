
FROM  nexushost.localdomain:8082/centos7.2
# ajout du certificat de nexus
ADD ca.crt .
ADD script.sh /root/
RUN chmod a+x /root/script.sh
#execution script
CMD  ["/root/script.sh"]
