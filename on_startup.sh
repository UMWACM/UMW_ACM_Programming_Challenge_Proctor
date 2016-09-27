#!/bin/bash

pip install telnetsrv
pip3 install telnetsrv

echo " = = = = Finding telnetsrvlib..."
find / -name 'telnetsrvlib' 2>/dev/null



# Copy our www directory to nginx www directory
cp -fR www/ /usr/share/nginx/html/

# todo copy python code to cgi-bin

# todo config nginx
