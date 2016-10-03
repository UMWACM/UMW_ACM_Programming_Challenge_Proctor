#!/bin/zsh

export DOCKER_HOST=tcp://ec2-107-20-40-67.compute-1.amazonaws.com:2375

pass=default_pass_0001
#printf 'mysql root pw: '
#read -n pass
#echo pass is $pass

docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=$pass -d mysql/mysql-server
docker run --name acm-biweekly-proctor --publish 80:80 --link mysql-container:mysql -d 65cd5f455a26

#todo debug the problem beind this hack
docker exec acm-biweekly-proctor rsync -r /opt/acm_challenge_proctor/www/ /var/www/html

