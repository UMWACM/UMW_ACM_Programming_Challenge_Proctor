#!/bin/bash
# Working dir is /opt/acm_challenge_proctor

# Copy our www directory to nginx www directory
rsync -ah --progress www/ /var/www/html/

[[ -e /var/www/html/index.php ]] && rm /var/www/html/index.php

