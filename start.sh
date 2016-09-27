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
  cp --recursive /dev_code/* ./
else
  # Get pushed git changes on startup
  echo 'Running git pull...'
  git pull
fi

chmod +x on_startup.sh
./on_startup.sh

# Start python telnet server
python3 src/telnet_server.py &

# Start nginx server
/usr/sbin/nginx &

echo 'All servers started!'

while [[ true ]]; do
  # add logging capabilities here?
  sleep 1
done
