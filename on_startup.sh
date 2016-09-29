#!/bin/bash

# Copy our www directory to nginx www directory
cp -fR www/ /usr/share/nginx/html/

cp config/php-fpm.conf /etc/php/php-fpm.conf
cp config/nginx.conf /etc/nginx/nginx.conf

# Start FastCGI PHP server
php-fpm --daemonize &

# Start nginx server
nginx &



