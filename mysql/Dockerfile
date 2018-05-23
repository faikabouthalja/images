FROM nexushost.localdomain:8082/debian:8
RUN groupadd -r mysql && useradd -r -g mysql mysql

# definir variable environnement
ENV DEBIAN_FRONTEND="noninteractive" 

#installation dépendences
RUN apt-get update && \
    apt-get install  -y lsb-release && \
   apt-get install -y  apt-utils &&\
   apt-get install -y  wget 
# installation gosu depuis nexus
RUN  wget -O /usr/local/bin/gosu  https://admin:admin123@192.168.17.133:8444/repository/projet/gosu/amd64/gosu \
     && chmod +x /usr/local/bin/gosu


RUN mkdir /docker-entrypoint-initdb.d

# installation mysql
RUN  wget https://admin:admin123@192.168.17.133:8444/repository/projet/mysql/5.7/debian/mysql-apt-config_0.7.3-1_all.deb \
    && dpkg -i mysql-apt-config_0.7.3-1_all.deb  && \
    apt-get update -y && \
    apt-get install -y --force-yes mysql-community-server && \
    rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod a+x /var/run/mysqld


VOLUME /var/lib/mysql

#copie fichiers config mysql
COPY config/ /etc/mysql/
# script config mysql
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh 

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
