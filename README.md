This image extends the official PHP-FPM image with the following additions:

# Set `date.timezone` ini setting
*Default:* `Europe/Budapest`

The timezone is configurable by the `php_timezone` docker build arg: `docker build --build-arg php_timezone="Europe/Budapest" .`

# Set `memory_limit` ini setting
*Default:* `512M`

The memory limit is configurable by the `php_memory_limit` docker build arg: `docker build --build-arg php_memory_limit="512M" .`

# Install a system-wide locale
*Default:* `hu_HU.UTF-8 UTF-8` + `en_US.UTF-8 UTF-8`

This is required by PHP date formatting functions like `strftime('%B')`.

The installed locales are configurable by the `locales` docker build arg: `docker build --build-arg locales="hu_HU.UTF-8 UTF-8" .`

# Configure some PHP ini settings
Some recommended ini settings are configured by default. The `conf.d` folder contains these ini files. The origin of these settings are:

* http://symfony.com/doc/current/performance.html
* https://github.com/krakjoe/apcu/blob/v5.1.11/INSTALL

# Install additional PHP extensions
By default `xdebug` is not installed, but you can rebuild the image with the following option to enable it: `--build-arg xdebug="1"`

Just to highlight some extensions:
* apcu
* intl
* imagick
* memcached
* mongodb
* redis

```
docker run --rm slaci/php-fpm:7.1 php -m
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
libxml
mbstring
mcrypt
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