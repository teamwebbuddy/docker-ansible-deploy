# use stable alpine php 7.4 as the base image - ubuntu 20.04 uses php 7.4
FROM php:7.4-fpm-alpine

# install ansible and ansistrano
RUN apk add --no-cache ansible \
    && ansible-galaxy install ansistrano.deploy,3.6.0

# install hugo - keep the same version as used by lando in the www.webbuddy.com.au repo
ENV HUGO_VERSION 0.77.0
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
  && php /tmp/composer-setup.php --install-dir=/usr/bin --filename=composer --1

# install php extensions
RUN apk add --no-cache \
    freetype-dev \
    icu-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
  && docker-php-ext-configure gd \
    --enable-gd \
    --with-freetype \
    --with-jpeg \
  && docker-php-ext-install \
    bcmath \
    gd \
    intl \
    pdo_mysql \
    soap \
    sockets \
    xsl \
    zip
