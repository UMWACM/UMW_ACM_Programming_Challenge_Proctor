# builds https://github.com/Jeffrey-P-McAteer/UMW_ACM_Programming_Challenge_Proctor

SHELL := /bin/bash

# Change this to wherever your challenge dir is
ChallengesDir=/Users/jeffrey/Projects/ACM_Challenges
TestServer=localhost

all:
	./setup.sh
	make build

build:
	chmod +x ./build.sh; ./build.sh

test: push
	chmod +x ./test.sh
	./test.sh || make stop_test

# Cleans things up after a failed test
stop_test:
	@echo "Stopping test environment..."
	@-docker stop acm_dev_proctor
	@-docker rm acm_dev_proctor
	@echo; echo "[ Test Failed ]"; echo
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
	python -c "print 'Deploy took', ( $$(cat /tmp/.acm_biweekly_deploy_end) - $$(cat /tmp/.acm_biweekly_deploy_begin) ), 'seconds'"

