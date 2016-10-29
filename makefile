# https://github.com/Jeffrey-P-McAteer/UMW_ACM_Programming_Challenge_Proctor

# Change this to wherever your challenge dir is
ChallengesDir=/Users/jeffrey/Projects/ACM_Challenges
TestServer=localhost

all: build

configure:
	hash docker || { \
		uname -a; \
		sudo apt-get update; \
		sudo apt-get install apt-transport-https ca-certificates; \
		sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D; \
		echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list; \
		sudo apt-get update; \
		sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual; \
		sudo apt-get install linux-image-generic-lts-trusty; \
		sudo apt-get install docker-engine; \
		sudo service docker start; \
	}

build:
	docker build . -t jeffreypmcateer/acm-programming-challenge-proctor
	cd Sandbox; docker build . -t jeffreypmcateer/acm-programming-challenge-sandbox

test: push
	docker pull jeffreypmcateer/acm-programming-challenge-proctor
	docker pull jeffreypmcateer/acm-programming-challenge-sandbox
	docker run --name acm_dev_proctor \
		-v /tmp \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		--volume "$(shell pwd)":/dev_code/ \
		--volume $(ChallengesDir):/challenge_db/ \
		--publish 8080:80 \
		jeffreypmcateer/acm-programming-challenge-proctor &
	# wait for server to come up
	sleep 16
	[[ "$$(w3m -dump http://$(TestServer):8080/ | head -n 1)" == "UMW ACM Bi-Weekly Programming Competition" ]] || make stop_test
	
	echo; echo "[ All Tests Passed ]"; echo
	@-docker stop acm_dev_proctor
	@-docker rm acm_dev_proctor
	
 
stop_test:
	@-docker stop acm_dev_proctor
	@-docker rm acm_dev_proctor
	echo; echo "[ Test Failed ]"; echo
	@false

web_test_py:
	curl -X POST -F 'TeamName=Some_Team' \
							 -F 'ContactEmails=Doze_Emails' \
							 -F 'ProblemID=d9615f' \
							 -F 'Language=Python' \
							 -F 'SolutionCode=@/Users/jeffrey/Downloads/easy.py' \
							 http://localhost:8080/submit.php

web_test_java:
	curl -X POST -F 'TeamName=Some_Team' \
							 -F 'ContactEmails=Doze_Emails' \
							 -F 'ProblemID=d9615f' \
							 -F 'Language=Java' \
							 -F 'SolutionCode=@/Users/jeffrey/Downloads/easy.java' \
							 http://localhost:8080/submit.php

# Does not go into background
run:
	docker run --name acm_proctor \
	  -v /tmp \
	  --volume /var/run/docker.sock:/var/run/docker.sock \
		--volume $(ChallengesDir):/challenge_db/ \
		--publish 80:80 \
		jeffreypmcateer/acm-programming-challenge-proctor:latest

# Runs as daemon in background
launch:
	docker run -d --name acm_proctor \
	  -v /tmp \
	  --volume /var/run/docker.sock:/var/run/docker.sock \
		--volume $(ChallengesDir):/challenge_db/ \
		--publish 80:80 \
		jeffreypmcateer/acm-programming-challenge-proctor:latest
		
push:
	docker push jeffreypmcateer/acm-programming-challenge-proctor
	cd Sandbox; docker push jeffreypmcateer/acm-programming-challenge-sandbox

deploy:
	-[[ $(shell hostname) == "Jeffreys-MacBook-Pro.local" ]] && make deploy_from_jeff

deploy_from_jeff:
	date +%s > /tmp/.acm_biweekly_deploy_begin
	make push
	ssh ec2 "git clone https://github.com/Jeffrey-P-McAteer/UMW_ACM_Programming_Challenge_Proctor.git; cd UMW_ACM_Programming_Challenge_Proctor; git pull; sudo docker stop acm_proctor; sudo docker rm acm_proctor; sudo docker pull jeffreypmcateer/acm-programming-challenge-proctor; sudo docker pull jeffreypmcateer/acm-programming-challenge-sandbox; sudo make launch;"
	date +%s > /tmp/.acm_biweekly_deploy_end
	python -c "print 'Deploy took', ( $(cat /tmp/.acm_biweekly_deploy_begin) - $(cat /tmp/.acm_biweekly_deploy_end) ), 'seconds'"

