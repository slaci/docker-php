This image extends the official PHP-FPM image with the following additions:

# PHP INI settings
Some recommended ini settings are configured by default. The `conf.d` folder contains these ini files.
The origin of these settings are:

* http://symfony.com/doc/current/performance.html
  * `realpath_cache_size`=4096K
  * `realpath_cache_ttl`=600
  * `opcache.max_accelerated_files`=20000
  * `opcache.memory_consumption`=256
* https://github.com/krakjoe/apcu/blob/v5.1.11/INSTALL
  * `apc.shm_size`=32M
  * `apc.ttl`=7200
  * `apc.enable_cli`=1

Additional defaults:
* `date.timezone`: Europe/Budapest
* `memory_limit`: 512M

## Mount additional ini files
It is possible to mount custom ini files into the `/usr/local/etc/php/conf.d/conf.d` directory, so you can add new settings or override the
default ones without rebuilding the image.

Example (the `-v` option [mounts](https://docs.docker.com/storage/volumes/) the override.ini file from the current directory):
```shell script
echo "memory_limit=128M" > override.ini
docker run --rm -v ${PWD}/override.ini:/usr/local/etc/php/conf.d/zzz-override.ini slaci/php-fpm:latest php -i | grep memory_limit
memory_limit => 128M => 128M
```

Or by [docker-compose](https://docs.docker.com/compose/):
```yaml
version: "3.4"
services:
    php:
        image: slaci/php-fpm:latest
        volumes:
          - "./override.ini:/usr/local/etc/php/conf.d/zzz-override.ini"
```
```shell script
echo "memory_limit=128M" > override.ini
docker-compose up -d
docker-compose exec php php -i | grep memory_limit
memory_limit => 128M => 128M
```

# Install a system-wide locale
*Default:* `hu_HU.UTF-8 UTF-8` + `en_US.UTF-8 UTF-8`

This is required by PHP date formatting functions like `strftime('%B')`.

The locales are configurable by rebuilding the image using the `locales` docker build arg: `docker build --build-arg locales="hu_HU.UTF-8 UTF-8" .`

# PHP extensions
By default `xdebug` is not installed, but you can rebuild the image with the following option to enable it: `--build-arg xdebug="1"`.

## Installed pecl extensions by default:
* apcu
* intl
* imagick
* ldap
* memcached
* mongodb
* redis

## All installed extensions
```
docker run --rm slaci/php-fpm:latest php -m
[PHP Modules]
apcu
bcmath
bz2
calendar
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
gmp
hash
iconv
igbinary
imagick
intl
json
ldap
libxml
mbstring
memcached
mongodb
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
shmop
SimpleXML
soap
sockets
sodium
SPL
sqlite3
standard
sysvmsg
sysvsem
sysvshm
tokenizer
xml
xmlreader
xmlrpc
xmlwriter
xsl
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```