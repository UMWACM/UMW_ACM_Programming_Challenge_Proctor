#!/bin/bash

if [[ "$(id -u)" != "0" ]]; then
   echo 'This script must be run as root' 1>&2
   exit 1
fi

echo 'Executing startup script'

# Move into directory this script resides in
cd $(dirname $(readlink -f "$0"))

# Test if we are developing
if [[ -d /dev_code ]]; then
  echo 'Copying from /dev/code....'
  cp -r /dev_code/ ./
else
  # Get pushed git changes on startup
  echo 'Running git pull...'
  git pull
fi

# Copy our www directory to nginx www directory
cp -fR www/ /usr/share/nginx/html/

# todo copy python code to cgi-bin

# todo config nginx

# Start python telnet server
su nobody -c python src/telnet_server.py &

# Start nginx server
su nobody -c /usr/sbin/nginx &

echo 'All servers started!'

while [[ true ]]; do
  # add logging capabilities here?
  bash
  sleep 1
done
