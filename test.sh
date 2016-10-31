source .user_config

date +%s > /tmp/.acm_biweekly_test_begin
docker pull jeffreypmcateer/acm-programming-challenge-proctor
docker pull jeffreypmcateer/acm-programming-challenge-sandbox
docker run --name acm_dev_proctor \
  -v /tmp \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume "$(pwd)":/dev_code/ \
  --volume "$q_dir":/challenge_db/ \
  --publish 8080:80 \
  jeffreypmcateer/acm-programming-challenge-proctor &

# wait for server to come up
sleep 16

./tests/webpage_opens.sh $test_server || exit 1


echo; echo "[ All Tests Passed ]"; echo
docker stop acm_dev_proctor >/dev/null
docker rm acm_dev_proctor >/dev/null
date +%s > /tmp/.acm_biweekly_test_end
python -c "print 'Tests took', ( $(cat /tmp/.acm_biweekly_test_end) - $(cat /tmp/.acm_biweekly_test_begin) ), 'seconds'"
exit 0