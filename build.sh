#!/bin/bash

date +%s > /tmp/.acm_biweekly_build_begin

if [[ ! -e .user_config]]; then
  ./setup.sh
fi

source .user_config

if ! hash openssl; then
  echo "Must install openssl to build"
  exit 1
fi

if [[ "$ACM_BIWEEKLY_ADMIN_USER" == "" ]]; then
  echo "Must set ACM_BIWEEKLY_ADMIN_USER variable to build"
  exit 1
fi

if [[ "$ACM_BIWEEKLY_ADMIN_PASS" == "" ]]; then
  echo "Must set ACM_BIWEEKLY_ADMIN_PASS variable to build"
  exit 1
fi

echo -n "$ACM_BIWEEKLY_ADMIN_USER:" >> ./conf/htpasswd
echo "$ACM_BIWEEKLY_ADMIN_PASS" | openssl passwd -apr1 -stdin >> ./conf/htpasswd
docker build -t jeffreypmcateer/acm-programming-challenge-proctor .
cd Sandbox; docker build -t jeffreypmcateer/acm-programming-challenge-sandbox .; cd ..;

date +%s > /tmp/.acm_biweekly_build_end

if hash python; then
  python -c "print('Build took', ( $(cat /tmp/.acm_biweekly_build_end) - $(cat /tmp/.acm_biweekly_build_begin) ), 'seconds')"
else
  echo "Install python to display build time"
fi

rm /tmp/.acm_biweekly_build_begin /tmp/.acm_biweekly_build_end
