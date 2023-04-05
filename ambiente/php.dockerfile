FROM php:8.1-fpm-alpine

WORKDIR /var/www/html

RUN apk add zip libzip-dev libgd libpng-dev libjpeg-turbo-dev freetype-dev && \
    apk add --no-cache gmp gmp-dev
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ --allow-untrusted  gnu-libiconv=1.15-r3
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo pdo_mysql bcmath zip gmp gd
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ARG USER_ID
ARG GROUP_ID
RUN addgroup -g ${GROUP_ID} -S www && adduser -u ${USER_ID} -S www -G www
USER www

EXPOSE 9000
