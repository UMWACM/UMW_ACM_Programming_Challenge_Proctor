#!/bin/bash

# Setup variables
server=${1}

# Check validity of variables
if ! ping -c 1 -W 1 ${server} > /dev/null 2>&1; then
  echo "Server at $server is unreachable!"
  exit 1
fi

# Run more detailed tests
webpage_contents=$(w3m -dump http://:8080/) # todo: this may hang, can we set short timeout?
if ! grep -q "UMW ACM Bi-Weekly Programming Competition" <<< "${webpage_contents}"; then
  echo "Homepage does not contain title!"
  exit 1
fi

# Declare test has passed
echo "Webserver is online & webpage opens"
exit 0