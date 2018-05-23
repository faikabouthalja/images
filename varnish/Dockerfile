FROM  nexushost.localdomain:8082/debian:8

### installation dépendences ###
RUN apt-get install -y wget libedit2 libjemalloc1 libvarnishapi1 init-system-helpers gcc libc6-dev && \
    apt-get -f -y install

### installation varnish ###
RUN  wget https://admin:admin123@192.168.17.133:8444/repository/projet/varnish/4.0.2/varnish_4.0.2-1+deb8u1_amd64.deb && \
     dpkg -i varnish_4.0.2-1+deb8u1_amd64.deb

### script demarrage varnish ###
COPY entrypoint /
RUN chmod a+x /entrypoint

EXPOSE 80
CMD ["/entrypoint"]
