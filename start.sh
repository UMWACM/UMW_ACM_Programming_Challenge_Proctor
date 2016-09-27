#!/bin/bash

if [[ "$(id -u)" != "0" ]]; then
   echo 'This script must be run as root' 1>&2
   exit 1
fi

echo 'Executing startup script'

# Move into directory this script resides in
cd $(dirname $(readlink -f "$0"))

original_start_hash=$(md5sum start.sh)

# Test if we are developing
if [[ -d /dev_code ]]; then
  echo 'Copying from /dev/code....'
  cp -r /dev_code/ ./
else
  # Get pushed git changes on startup
  echo 'Running git pull...'
  git pull
fi

newer_start_hash=$(md5sum start.sh)
# If our git pull/cp -r has changed the start.sh file, reload it
if [[ "$original_start_hash" != "$newer_start_hash" ]]; then
  exec start.sh
fi

# Copy our www directory to nginx www directory
cp -fR www/ /usr/share/nginx/html/

# todo copy python code to cgi-bin

# todo config nginx

# Start python telnet server
su untrusted -c python src/telnet_server.py &

# Start nginx server
su untrusted -c /usr/sbin/nginx &

echo 'All servers started!'

while [[ true ]]; do
  # add logging capabilities here?
  sleep 1
done
