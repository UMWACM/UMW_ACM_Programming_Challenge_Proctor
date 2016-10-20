# UMW ACM Programming Challenge Proctor
This repository holds code for the UMW ACM programming challenge proctor. The goal is to fix a number of short-term issues discovered during the first month of challenges, as well as fix the long-term issue regarding hosting. The new design revolves around a pair of Docker containers which provide web interfaces and sandboxing capabilities.

## Getting up and running

Prerequisite: docker. You do not need to have a docker server on your own machine, but you must have a client which is connected to a docker server somewhere.

Running `make` will build both docker images and run a test container.
Once running, you may browse to `localhost:8080` to use the proctor web interface. The test container is connected to your local filesystem for development, changing any code in the current directory will cause a script to copy it into the running container. Note that some changes, like changes to the Dockerfile, require the container to be brought down and rebuilt.

## Changelog

### v1.0
Changed the challenge period to begin on Fridays instead of Mondays.
#### Language support
* C
* Java
* Python
