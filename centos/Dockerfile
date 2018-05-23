FROM scratch
#### Ajout du tar centos
ADD centos7.tar.xz /
#### ajout du script ####
ADD script.sh /
#### ajout droits d execution au script ####
RUN chmod a+x /script.sh
#### execution script ####
CMD /script.sh
