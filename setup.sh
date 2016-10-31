#!/bin/bash

if [[ -e .user_config ]]; then
  cat <<EOF
You are already set up, but if you would like to
reset things remove the .user_config file.
EOF
  exit 0
fi

printf 'Where is your questions directory? '
read q_dir
echo "export q_dir=$q_dir" > .user_config

printf 'Where is your test server located? [localhost] '
read test_server
if [[ "$test_server" == "" ]]; then
  test_server=localhost
fi
echo "export test_server=$test_server" >> .user_config

printf 'What username are you using for the admin page? '
read ACM_BIWEEKLY_ADMIN_USER
echo "export ACM_BIWEEKLY_ADMIN_USER=$ACM_BIWEEKLY_ADMIN_USER" >> .user_config

printf 'What password are you using for the admin page? '
read ACM_BIWEEKLY_ADMIN_PASS
echo "export ACM_BIWEEKLY_ADMIN_PASS=$ACM_BIWEEKLY_ADMIN_PASS" >> .user_config

