# https://github.com/Jeffrey-P-McAteer/UMW_ACM_Programming_Challenge_Proctor

# Look at me:
# http://container-solutions.com/understanding-volumes-docker/
# https://docs.docker.com/engine/tutorials/dockervolumes/
# http://stackoverflow.com/questions/33210678/docker-mount-directory-from-one-container-to-another

all: build test
	
build:
	docker build . -t jeffreypmcateer/acm-programming-challenge-proctor
	cd Sandbox; docker build . -t jeffreypmcateer/acm-programming-challenge-sandbox

test:
	docker run --name acm_proctor \
		-v /tmp \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		--volume "$(shell pwd)":/dev_code/ \
		--volume /Users/jeffrey/Projects/ACM_Challenges:/challenge_db/ \
		--publish 8080:80 \
		jeffreypmcateer/acm-programming-challenge-proctor

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

run:
	docker run --volume /var/run/docker.sock:/var/run/docker.sock \
		--volume "$(shell pwd)":/db_backups/ \
		--publish 80:80 \
		jeffreypmcateer/acm-programming-challenge-proctor

push:
	docker push jeffreypmcateer/acm-programming-challenge-proctor
	cd Sandbox; docker push jeffreypmcateer/acm-programming-challenge-sandbox

#deploy:
	