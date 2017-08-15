FROM php:7.1-fpm

LABEL maintainer="slaci1@gmail.com"

ARG locales='hu_HU.UTF-8 UTF-8\nen_US.UTF-8 UTF-8'
ARG xdebug="0"
ARG memcached="1"
ARG imagick="1"
ARG redis="1"
ARG apcu="1"

COPY php.ini "$PHP_INI_DIR/"

RUN set -xe \
    && DevDeps=" \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
      libbz2-dev \
      libgmp-dev \
      libicu-dev \
      libxml2-dev \
      libxslt1-dev \
      zlib1g-dev \
      libpq-dev" \
    && Deps=" \
      locales \
      libpng12-0 \
      libjpeg62-turbo \
      libfreetype6 \
      libicu52 \
      libxslt1.1 \
      libmcrypt4 \
      libpq5" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $Deps $DevDeps \
    && echo $locales >> /etc/locale.gen \
    && locale-gen \
    && docker-php-ext-install -j$(nproc) \
      opcache \
      intl \
      iconv \
      mcrypt \
      mysqli \
      pdo_mysql \
      pdo_pgsql \
      bcmath \
      gmp \
      calendar \
      exif \
      gettext \
      soap \
      sockets \
      shmop \
      sysvmsg \
      sysvsem \
      sysvshm \
      xmlrpc \
      xsl \
      bz2 \
      zip \
      pcntl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $DevDeps \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install igbinary \
    && docker-php-ext-enable igbinary

RUN set -e \
    && if [ "${xdebug}" = "1" ]; \
    then \
        pecl install xdebug \
        && docker-php-ext-enable xdebug; \
    fi

RUN set -e \
    && if [ "${redis}" = "1" ]; \
    then \
        pecl install redis \
        && docker-php-ext-enable redis; \
    fi

RUN set -e \
    && if [ "${apcu}" = "1" ]; \
    then \
        pecl install apcu \
        && docker-php-ext-enable apcu; \
    fi

RUN set -e \
    && if [ "${memcached}" = "1" ]; \
    then \
      apt-get update \
      && apt-get install -y --no-install-recommends libmemcached-dev libmemcached11 zlib1g-dev \
      && pecl install memcached && docker-php-ext-enable memcached \
      && apt-get purge -y zlib1g-dev \
      && rm -rf /var/lib/apt/lists/*; \
    fi

RUN set -e \
    && if [ "${imagick}" = "1" ]; \
    then \
      apt-get update \
      && apt-get install -y --no-install-recommends libmagickwand-dev \
      && pecl install imagick \
      && docker-php-ext-enable imagick \
      && rm -rf /var/lib/apt/lists/*; \
    fi

COPY conf.d "$PHP_INI_DIR/conf.d/"

