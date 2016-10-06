#!/bin/bash
# Working dir is /opt/acm_challenge_proctor

echo '[ Update ] Code changed in /dev_code'
rsync -ah --progress /dev_code/ /opt/acm_challenge_proctor/
rsync -ah --progress /opt/acm_challenge_proctor/www/ /var/www/html/

chown -Rf nginx.nginx /var/www/html
