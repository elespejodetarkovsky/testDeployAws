FROM alpine:latest

ENV ACCEPT_EULA=Y

#instalo nginx
RUN apk update && apk upgrade
RUN apk add bash
RUN apk add nginx
RUN apk add php8 php8-fpm php8-opcache
RUN apk add php8-gd php8-zlib php8-curl php8-phar php8-mbstring php8-openssl
RUN apk add curl

COPY server/etc/nginx /etc/nginx

COPY server/etc/php /etc/php8
COPY src /usr/share/nginx/html

RUN mkdir /var/run/php

WORKDIR /usr/share/nginx/html


#RUN apk update && apk add zlib1g-dev g++ git libicu-dev zip libzip-dev zip unixodbc-dev gnupg2 libodbc1 libxml2-dev apt-transport-https \
#     && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#     && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apk update
#RUN apk add wget
#
#RUN wget http://ftp.br.debian.org/debian/pool/main/g/glibc/multiarch-support_2.24-11+deb9u4_amd64.deb \
#    && dpkg -i multiarch-support_2.24-11+deb9u4_amd64.deb \

#RUN apk update && apk add -y msodbcsql17
#
#RUN docker-php-ext-install intl opcache pdo pdo_mysql \
#     && pecl install apcu \
#     && pecl install sqlsrv \
#     && pecl install pdo_sqlsrv \
#     && docker-php-ext-enable apcu \
#     && docker-php-ext-configure zip \
#     && docker-php-ext-install zip \
#     && docker-php-ext-enable sqlsrv pdo_sqlsrv

#WORKDIR /var/www/project

# INSTALL COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

#instalo node
#RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
#RUN apk add nodejs
RUN apk add --update nodejs npm

#instalo yarn
RUN npm install --global yarn

EXPOSE 80

EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["/bin/bash", "-c", "php-fpm8 && chmod 777 /var/run/php/php8-fpm.sock && chmod 755 /usr/share/nginx/html/* && nginx -g 'daemon off;' && composer install"]