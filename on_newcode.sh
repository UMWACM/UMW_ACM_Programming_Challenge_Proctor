#!/bin/bash

echo 'on_newcode.sh is running'
pwd

rsync -ah --progress /dev_code/www/ /var/www/html/

