#!/bin/bash
# Working dir is /opt/acm_challenge_proctor

rsync -ah --progress /dev_code/www/ /var/www/html/

