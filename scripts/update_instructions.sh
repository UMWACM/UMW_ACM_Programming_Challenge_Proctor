#!/bin/bash

# Is moved to /etc/periodic/15min/ and is executed by cron every 15 min

[[ ! -e /tmp/old_instructions ]] && touch /tmp/old_instructions
[[ ! -e /tmp/new_instructions ]] && touch /tmp/new_instructions

curl --silent 'https://docs.google.com/document/d/1-2Sj1UUN2K18qEZqJrUxDspsVOpAXDmIqsBYpZBlxr4/pub?embedded=true' > /tmp/new_instructions

old_hash=$(cat /tmp/old_instructions | sha256sum)
new_hash=$(cat /tmp/new_instructions | sha256sum)

cp /tmp/new_instructions /tmp/old_instructions

if [[ "$old_hash" != "$new_hash" ]]; then
  echo "$old_hash" " != " "$new_hash"
  cp /tmp/new_instructions /var/www/html/generated_instructions.html
fi

