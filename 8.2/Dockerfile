ARG FROM_VERSION=8.2.0
FROM php:${FROM_VERSION}-fpm-bullseye

LABEL maintainer="slaci1@gmail.com"

ARG locales='hu_HU.UTF-8 UTF-8\nen_US.UTF-8 UTF-8'

RUN set -xe \
    && DevDeps=" \
        libbz2-dev \
        libfreetype6-dev \
        libgmp-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libmagickwand-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpng-dev \
        libpq-dev \
        libwebp-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
        libzip-dev \
        zlib1g-dev" \
    && Deps=" \
        locales \
        imagemagick-6.q16 \
        libfreetype6 \
        libjpeg62-turbo \
        libicu67 \
        libldap-2.4-2 \
        libmcrypt4 \
        libmemcached11 \
        libmemcachedutil2 \
        libpng16-16 \
        libpq5 \
        libltdl7 \
        libwebp6 \
        libzip4 \
        libxpm4 \
        libxslt1.1" \
    && PeclModules=" \
        apcu \
        imagick \
        memcached \
        redis \
        igbinary \
        mongodb" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $Deps $DevDeps \
    && echo $locales >> /etc/locale.gen \
    && locale-gen \
    && docker-php-ext-install -j$(nproc) \
        bz2 \
        bcmath \
        calendar \
        exif \
        gettext \
        gd \
        gmp \
        iconv \
        intl \
        ldap \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        xsl \
        zip \
    && docker-php-ext-configure gd --with-jpeg --with-webp --with-xpm --with-freetype \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install $PeclModules \
    && docker-php-ext-enable $PeclModules \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $DevDeps \
    && rm -rf /var/lib/apt/lists/*

ARG xdebug="0"
RUN set -xe; \
    if [ "${xdebug}" = "1" ]; \
    then \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    fi

COPY conf.d "$PHP_INI_DIR/conf.d/"
