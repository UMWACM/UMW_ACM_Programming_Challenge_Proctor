#!/bin/bash

echo '[ Update ] Code changed in /dev_code'
rsync -ah --progress /dev_code/ /opt/acm_challenge_proctor/
rsync -ah --progress /opt/acm_challenge_proctor/www/ /var/www/html/

# Permissions
chmod 777 /opt/acm_challenge_proctor/scripts/*.sh
chmod 666 /var/lib/acm_challenge_proctor/*.db
chmod 777 /var/lib/acm_challenge_proctor/
chown -Rf nginx.nginx /var/www/html

