killall_docker () {
  if [[ "$(docker ps -a | tail -n 1 | cut -d' ' -f1)" = "CONTAINER" ]]
  then
    echo 'Stopped all docker containers'
    return
  fi
  var=$(docker ps -a | tail -n 1 | cut -d' ' -f1) 
  docker stop "$var"
  docker rm -f "$var"
  killall_docker
}
killall_docker

docker rmi -f jeffreypmcateer/acm-programming-challenge-proctor jeffreypmcateer/acm-programming-challenge-sandbox

