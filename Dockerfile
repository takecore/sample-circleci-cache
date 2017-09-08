FROM php:7-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      libmcrypt-dev \
      libxml2-dev \
      libfreetype6-dev \
      libpng12-dev \
      libjpeg62-turbo-dev \
      unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include \
      --with-png-dir=/usr/include \
      --with-jpeg-dir=/usr/include \
    && docker-php-ext-install \
      pdo \
      pdo_mysql \
      mbstring \
      tokenizer \
      xml \
      mcrypt \
      gd \
      pcntl \
      zip \
    && a2enmod rewrite

ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_VERSION 1.1.3

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php

WORKDIR /usr/src/app
