#!/bin/bash

# Permissions
chmod 777 /opt/acm_challenge_proctor/scripts/*.sh
chmod 666 /var/lib/acm_challenge_proctor/*.db
chmod 777 /var/lib/acm_challenge_proctor/

# Test if we are developing
if [[ -d /dev_code ]]; then
  echo '[ Updating ] from /dev_code....'
  rsync -ah --progress /dev_code/ /opt/acm_challenge_proctor/
  when-changed -r /dev_code /opt/acm_challenge_proctor/scripts/on_newcode.sh &
  /opt/acm_challenge_proctor/scripts/on_newcode.sh
fi

# Remove the default php file if it exists
[[ -e /var/www/html/index.php ]] && rm /var/www/html/index.php

# Copy our www directory to nginx www directory
rsync -ah --progress /opt/acm_challenge_proctor/www/ /var/www/html/
chown -Rf nginx.nginx /var/www/html

/opt/acm_challenge_proctor/scripts/update_instructions.sh
cp /opt/acm_challenge_proctor/scripts/update_instructions.sh /etc/periodic/15min/

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf

echo '[ Server Started ]'

#while [[ true ]]; do
#  sleep 0.5
#done
