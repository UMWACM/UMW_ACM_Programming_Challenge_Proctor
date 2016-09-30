#!/bin/bash

# Is moved to /etc/periodic/15min/ and is executed by cron every 15 min

[[ ! -e /tmp/old_instructions ]] && touch /tmp/old_instructions

curl 'https://docs.google.com/document/d/1-2Sj1UUN2K18qEZqJrUxDspsVOpAXDmIqsBYpZBlxr4/pub?embedded=true' > /tmp/new_instructions

old_hash=$(sha256sum /tmp/old_instructions)
new_hash=$(sha256sum /tmp/new_instructions)

mv /tmp/new_instructions /tmp/old_instructions

if [[ "$old_hash" != "$new_hash" ]]; then
  cp /tmp/new_instructions /var/www/html/generated_instructions.html
fi
