#!/bin/bash

# Always chown webroot for better mounting
chown -Rf nginx.nginx /var/www/html

# Move into directory this script resides in
cd $(dirname $(readlink -f "$0"))

# Test if we are developing
if [[ -d /dev_code ]]; then
  echo '[ Updating ] from /dev_code....'
  rsync -ah --progress /dev_code/ ./test_cases/
  when-changed -r /dev_code ./on_newcode.sh &
else
  # Get pushed git changes on startup
  echo '[ Updating ] git pull...'
  git pull
fi

chmod +x on_startup.sh
./on_startup.sh

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf

echo '[ Server Started ]'

while [[ true ]]; do
  sleep 0.5
done