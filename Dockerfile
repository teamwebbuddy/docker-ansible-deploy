# use stable alpine php 7.0 as the base image - ubuntu 16.04 uses php 7.0
FROM php:7.0-fpm-alpine

# install ansible and ansistrano
RUN apk add --no-cache ansible \
    && ansible-galaxy install ansistrano.deploy,2.9.1

# install hugo
ENV HUGO_VERSION 0.48
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit
RUN mkdir /usr/local/hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/hugo/
RUN tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
    && ln -s /usr/local/hugo/hugo /usr/local/bin/hugo \
    && rm /usr/local/hugo/${HUGO_BINARY}.tar.gz

# install git, openssh-client and tar
RUN apk add --no-cache \
    git \
    openssh-client \
    tar

# install composer
ADD https://getcomposer.org/installer /tmp/composer-setup.php
ADD https://composer.github.io/installer.sig /tmp/composer-setup.sig
RUN php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
  && php /tmp/composer-setup.php --install-dir=/usr/bin --filename=composer

# install php extensions
RUN apk add --no-cache \
    freetype-dev \
    icu-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    libxslt-dev \
  && docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install \
    gd \
    intl \
    mcrypt \
    pdo_mysql \
    soap \
    xsl \
    zip
