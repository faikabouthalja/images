FROM  nexushost.localdomain:8082/debian:8
# dossier apache
ENV HTTPD_PREFIX /usr/local/apache2
# ajout au path
ENV PATH $PATH:$HTTPD_PREFIX/bin
RUN mkdir -p "$HTTPD_PREFIX" \
	&& chown www-data:www-data "$HTTPD_PREFIX"
WORKDIR $HTTPD_PREFIX


#installation dépendances 
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		libapr1 \
		libaprutil1 \
		libaprutil1-ldap \
		libapr1-dev \
		libaprutil1-dev \
		libpcre++0 \
		libssl1.0.0 
# dépendances seulement installation a enlever après
RUN buildDeps='ca-certificates bzip2 gcc libpcre++-dev libssl-dev make wget ' \
	set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps 

# package httpd from nexus and install httpd et definir fichier log dans le fichier de config httpd.conf and removing dependencies un-needed
RUN wget https://admin:admin123@192.168.17.133:8444/repository/projet/httpd/2.2.34/httpd-2.2.34.tar.gz \
   && mkdir -p src/httpd \
	&&  tar -xzvf httpd-2.2.34.tar.gz  -C src/httpd --strip-components=1 \
	&& rm httpd-2.2.34.tar.gz \
	&& cd src/httpd \
	&& ./configure --enable-proxy --enable-proxy-fcgi --enable-so --enable-ssl --prefix=$HTTPD_PREFIX --enable-mods-shared=most \
	&& make -j"$(nproc)" \
	&& make install \
	&& cd ../../ \
	&& sed -ri 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g;s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; ' /usr/local/apache2/conf/httpd.conf \
	&& apt-get purge -y --auto-remove $buildDeps


# add sources for modules installation
RUN echo 'deb http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN echo 'deb-src http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
# installation modules apache necessaires
RUN apt-get update && apt-get install -y apache2-utils libapache2-mod-fastcgi  autoconf build-essential libapache2-mod-proxy-html libxml2-dev python

# installing mod proxy fcgi module from nexus
RUN cd / \ 
    && wget https://admin:admin123@192.168.17.133:8444/repository/projet/httpd/dependencies/modproxyfcgi/mod.tar.gz && \
    tar -xzvf mod.tar.gz && \
    cd mod-proxy-fcgi \
    && autoconf \
    && ./configure \
    && make \
    && make install

# ajout fichier de config
ADD httpd.conf /usr/local/apache2/conf/
ADD httpd-ssl.conf /usr/local/apache2/conf/extra/
# define use www-data
RUN usermod -u 1000 www-data

# ajout script démarrage httpd
COPY httpd-foreground /usr/local/bin/
RUN  chmod +x /usr/local/bin/httpd-foreground
RUN  dpkg-reconfigure --frontend noninteractive tzdata
# clean up and delete compilation chain
RUN rm -rf /usr/local/apache2/src /mod*
EXPOSE 443
EXPOSE 80
CMD ["httpd-foreground"]
