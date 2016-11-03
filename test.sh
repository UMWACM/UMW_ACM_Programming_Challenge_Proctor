source .user_config

date +%s > /tmp/.acm_biweekly_test_begin
docker run --name acm_proctor \
  -v /tmp \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume "$(pwd)":/dev_code/ \
  --volume "$q_dir":/challenge_db/ \
  --publish 8080:80 \
  jeffreypmcateer/acm-programming-challenge-proctor &

# wait for server to come up
sleep 12

./tests/webpage_opens.sh $test_server || exit 1
./tests/code_submit.sh $test_server || exit 1

echo; echo "[ All Tests Passed ]"; echo
date +%s > /tmp/.acm_biweekly_test_end
python -c "print 'Tests took', ( $(cat /tmp/.acm_biweekly_test_end) - $(cat /tmp/.acm_biweekly_test_begin) ), 'seconds'"

printf 'Remove test container?[y/n] '
read yn
if [[ "$yn" != n ]]; then
  echo "Removing test container"
  docker stop acm_proctor >/dev/null
  docker rm acm_proctor >/dev/null
fi

# Declare test has passed
echo "Test code submissions sent"
exit 0
