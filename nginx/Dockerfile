FROM nexushost.localdomain:8082/debian:8

RUN apt-get update -y && apt-get install libpcre3-dev build-essential libssl-dev  wget -y

RUN cd /opt && \
    wget https://admin:admin123@192.168.17.133:8444/repository/projet/nginx/1.13.8/nginx-1.13.8.tar.gz  && \
    tar -zxvf nginx-1.13.8.tar.gz && \
    cd nginx-1.13.8/ && \
    ./configure --prefix=/opt/nginx --conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/lock/nginx.lock \
	--with-http_ssl_module 	--with-http_gzip_static_module \
        --user=www-data --group=www-data  && \
    make && \
    make install

COPY nginx /etc/init.d/nginx
RUN chmod +x /etc/init.d/nginx && \
    update-rc.d -f nginx defaults && \
    mkdir /etc/nginx/sites-available && \
    mkdir /etc/nginx/sites-enabled

# clean up
RUN rm -rf /opt/nginx-1.13.8*
COPY entrypoint /
RUN chmod +x /entrypoint

CMD ["/entrypoint"]
