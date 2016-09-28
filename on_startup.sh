#!/bin/bash

# Copy our www directory to nginx www directory
cp -fR www/ /usr/share/nginx/html/

# todo copy python code to cgi-bin

# todo config nginx

cat > /etc/nginx/nginx.conf << EOF

user http;
worker_processes auto;
pcre_jit on;

events {
    worker_connections 2048;
}

http {
    include mime.types;
    default_type application/octet-stream;
    # include servers-enabled/*; # See Server blocks
}

EOF


# Start python telnet server
python2 src/telnet_server.py &

# Start nginx server
/usr/sbin/nginx &

