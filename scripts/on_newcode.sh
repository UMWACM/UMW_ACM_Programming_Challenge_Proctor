#!/bin/bash

echo '[ Update ] Code changed in /dev_code'
rsync -ah --progress /dev_code/ /opt/acm_challenge_proctor/ >/dev/null 2>&1
rsync -ah --progress /opt/acm_challenge_proctor/www/ /var/www/html/ >/dev/null 2>&1

# Permissions
chmod 777 /opt/acm_challenge_proctor/scripts/*.sh
chmod 777 /var/lib/acm_challenge_proctor/*.db
chmod 777 /var/lib/acm_challenge_proctor/
chown -Rf nginx.nginx /var/www/html

