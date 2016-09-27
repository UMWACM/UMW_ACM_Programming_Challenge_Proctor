#!/bin/bash

if [[ "$(id -u)" != "0" ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Move into directory this script resides in
cd $(dirname $(readlink -f "$0"))

# Copy our www directory to nginx www directory
cp -fR www/ /usr/share/nginx/html/

# todo copy python code to cgi-bin

# todo config nginx to 

# Start python telnet server
#nohup python src/telent_server.py >/tmp/telnet_server.out 2>/tmp/telnet_server.err &
su nobody -c nohup python src/telent_server.py >/tmp/telnet_server.out 2>/tmp/telnet_server.err &

