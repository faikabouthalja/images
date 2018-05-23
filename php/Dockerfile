FROM nexushost.localdomain:8082/debian:8
### installation dépendances
RUN tempDeps=' autoconf  dpkg-dev  file g++  gcc  libc-dev libpcre3-dev  make  pkg-config  re2c  ca-certificates  curl  libedit2  libsqlite3-0 wget dirmngr libxml2  xz-utils ' \ 
    set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $tempDeps

## fichier config php
ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d
# variables environnement php
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"
#get php7.0.25 package from nexus
RUN mkdir -p /usr/src; \
        cd /usr/src; \
        wget -O php.tar.xz  https://admin:admin123@192.168.17.133:8444/repository/projet/php/7.0.25/php-7.0.25.tar.xz ; \
        apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false  wget dirmngr
# copie script pour extract
COPY docker-php-source /usr/local/bin/
# installation php
RUN set -xe \
        && buildDeps="libcurl4-openssl-dev libedit-dev libsqlite3-dev libssl-dev libxml2-dev zlib1g-dev "  \
        && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
        && docker-php-source extract \
        && cd /usr/src/php \
        && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" \
	   && ./configure \
                --build="$gnuArch" --with-config-file-path="$PHP_INI_DIR" --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" --disable-cgi --enable-ftp \
                --enable-mbstring --enable-mysqlnd --with-curl --with-libedit --with-openssl --with-zlib --with-pcre-regex=/usr --with-libdir="lib/$debMultiarch" \
                --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data \
        && make -j "$(nproc)" \
        && make install \
        && make clean \
        && cd / \
        && docker-php-source delete \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
         && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false    $tempDeps \
        && pecl update-channels \
        && rm -rf /tmp/pear ~/.pearrc
# copie script config
COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/
# installation dependances 
RUN apt-get update && apt-get install -y apt-utils  wget git\
   unzip  cron  curl  libmcrypt-dev  libicu-dev libxml2-dev libxslt1-dev libfreetype6-dev \
   libjpeg62-turbo-dev libpng12-dev openssl ocaml openssh-server mysql-client

# installation packages php json zip soap ..
RUN docker-php-ext-install pdo pdo_mysql \
   &&  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-configure hash --with-mhash \
   && docker-php-ext-install -j$(nproc) mcrypt intl xsl gd zip pdo_mysql opcache soap bcmath json iconv sockets exif
RUN pecl install xdebug \
   &&  docker-php-ext-enable xdebug
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# delete  /usr/src installation package
RUN rm -rf /usr/src
# configurations a modifier dans fichiers de config
RUN set -ex \
        && cd /usr/local/etc \
        && if [ -d php-fpm.d ]; then \
                sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
                cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
        else \
                 mkdir php-fpm.d; \
                cp php-fpm.conf.default php-fpm.d/www.conf; \
                { \
                        echo '[global]'; \
                        echo 'include=etc/php-fpm.d/*.conf'; \
                } | tee php-fpm.conf; \
        fi \
        && { \
                echo '[global]'; \
                echo 'error_log = /proc/self/fd/2'; \
                echo; \
                echo '[www]'; \
                echo '; if we send this to /proc/self/fd/1, it never appears'; \
                echo 'access.log = /proc/self/fd/2'; \
                echo; \
                echo 'clear_env = no'; \
                echo; \
                echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
                echo 'catch_workers_output = yes'; \
        } | tee php-fpm.d/docker.conf \
        && { \
                echo '[global]'; \
                echo 'daemonize = no'; \
                echo; \
                echo '[www]'; \
                echo 'listen = [::]:9000'; \
        } | tee php-fpm.d/zz-docker.conf

WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]
