FROM  nexushost.localdomain:8082/debian:8

### installation dépendences ###
RUN apt-get update && apt-get install -y wget software-properties-common unzip && \
   apt-get install lsof -y
### installation jdk ###
RUN mkdir /opt/jdk/ \
    && wget  https://admin:admin123@192.168.17.133:8444/repository/projet/jdk/8u151/jdk-8u151-linux-x64.tar.gz \
    && tar -zxf jdk-8u151-linux-x64.tar.gz -C /opt/jdk \
    &&  update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_151/bin/java 100 \
    && update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_151/bin/javac 100
ENV SOLR_USER solr
ENV SOLR_UID 8983
RUN groupadd -r -g $SOLR_UID $SOLR_USER && \
  useradd -r -u $SOLR_UID -G $SOLR_USER -g $SOLR_USER $SOLR_USER

ENV JAVA_HOME="/opt/jdk/jdk1.8.0_151"

### installation solr 6.6.2 ###
RUN cd / && wget  https://admin:admin123@192.168.17.133:8444/repository/projet/solr/6.6.2/solr-6.6.2.tgz && \
   tar xvf solr-6.6.2.tgz && \
   ./solr-6.6.2/bin/install_solr_service.sh solr-6.6.2.tgz

# clean up delete src
RUN rm -rf /solr-6.6.2* 

#### ajout script démarrage solr
COPY entrypoint /
RUN chmod a+x /entrypoint
#### cleaning up
RUN rm -rf /jdk-8u151-linux-x64.tar.gz /solr-6.6.2.tgz \
    && apt-get purge -y --auto-remove wget


EXPOSE 8983
CMD ["/entrypoint"]
#CMD ["/bin/bash"]
