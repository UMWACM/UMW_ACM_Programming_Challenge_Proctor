#!/bin/bash

echo 'on_startup.sh is running'
pwd

# Copy our www directory to nginx www directory
rsync -ah --progress www/ /var/www/html/

#cp config/php-fpm.conf /etc/php/php-fpm.conf
#cp config/nginx.conf /etc/nginx/nginx.conf

# Start FastCGI PHP server
#php-fpm --daemonize &

# Start nginx server
#nginx &



