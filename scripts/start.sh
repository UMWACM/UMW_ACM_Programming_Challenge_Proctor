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
  ./on_newcode.sh
fi

# Copy our www directory to nginx www directory
rsync -ah --progress www/ /var/www/html/

# Remove the default php file if it exists
[[ -e /var/www/html/index.php ]] && rm /var/www/html/index.php

chmod +x *.sh

./update_instructions.sh
cp update_instructions.sh /etc/periodic/15min/

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf

echo '[ Server Started ]'

#while [[ true ]]; do
#  sleep 0.5
#done
