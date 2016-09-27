#!/bin/bash

if [[ "$(id -u)" != "0" ]]; then
   echo 'This script must be run as root' 1>&2
   exit 1
fi

echo 'Executing startup script'

# Move into directory this script resides in
cd $(dirname $(readlink -f "$0"))

original_start_hash=$(md5sum start.sh)
echo "original_start_hash=$original_start_hash"

# Test if we are developing
if [[ -d /dev_code ]]; then
  echo 'Copying from /dev/code....'
  cp --recursive /dev_code/* ./
else
  # Get pushed git changes on startup
  echo 'Running git pull...'
  git pull
fi

newer_start_hash=$(md5sum start.sh)
echo "newer_start_hash=$newer_start_hash"
# If our git pull/cp -r has changed the start.sh file, reload it
if [[ "$original_start_hash" != "$newer_start_hash" ]]; then
  echo 'start.sh has changed, running newer one...'
  exec start.sh
else
  echo 'start.sh has not changed. plus ome new test'
fi

# Copy our www directory to nginx www directory
cp -fR www/ /usr/share/nginx/html/

# todo copy python code to cgi-bin

# todo config nginx

# Start python telnet server
python3 src/telnet_server.py &

# Start nginx server
/usr/sbin/nginx &

echo 'All servers started!'

while [[ true ]]; do
  # add logging capabilities here?
  sleep 1
done
