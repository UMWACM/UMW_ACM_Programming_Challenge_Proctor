# UMW ACM Programming Challenge Proctor
This repository holds code for the UMW ACM programming challenge proctor. The goal is to fix a number of short-term issues discovered during the first month of challenges, as well as fix the long-term issue regarding hosting. The new design revolves around a pair of Docker containers which provide web interfaces and sandboxing capabilities.

## Current live system
This year's Programming Competition Coordinator, Jeffrey McAteer, has offered to host the official proctor on one of his AWS instances. UMW ACM has plans to aquire an ec2 account for a more permanent server, so check back here or on the latest instructions sheet for details.

Current Live URL: http://ec2-54-211-6-143.compute-1.amazonaws.com/

## Getting up and running

Prerequisites:
 * make, bash, curl, the usual utilities for building software
 * docker. You should have a docker daemon running on your local machine, or foward the appropriate ports (just 8080 for now) from the remote deamon to your local machine.

Running `make` will prompt you for ephemeral testing and authentication information, such as database credentials. These credentials must under no means be checked into this repository, and are stored in the ignored .user_config file. After collecting necessary information it will build the docker image. Initially this process may take some time (~5 minutes), as the base packages must be downloaded, installed and updated. Subsequent builds will be much faster due to docker's caching mechanism.

Running `make test` will run several test scripts found in the ./tests/ directory. After these have been performed, you will be prompted to remove the docker container. If you do not remove it, you may browse to `localhost:8080` to use the proctor web interface. The test container is connected to your local filesystem for development, changing any code in the current directory will cause a script to copy it into the running container. Note that some changes, like changes to the Dockerfile, require the container to be brought down and rebuilt.

## Administration
The web interface provides two utilities for the administration of the tests, reached by clicking the 'DB Admin' and 'Admin Leaderboard' tabs on the main page. Both are password-protected using the ephemeral credentials provided during setup. 'DB Admin' will take you to the phpLiteAdmin utility, which operates much like phpMyAdmin but uses the sqlite database. This may be used to back up or restore submission data. 'Admin Leaderboard' is simply a copy of the leaderboard which includes the email addresses and source code of submissions.

## Changelog

### v1.0
Changed the challenge period to begin on Fridays instead of Mondays. This is currently hard-coded in php.
#### Submission Language support
* C (untested)
* Java (tested)
* Python2 & 3 (tested)
