#!/bin/bash

# Copy our www directory to nginx www directory
cp -fR www/ /usr/share/nginx/html/

cp config/nginx.conf /etc/nginx/nginx.conf

# Start nginx server
/usr/sbin/nginx &



