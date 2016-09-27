# UMW ACM Programming Challenge Proctor

## Getting up and running

To get the most recent container running

`docker build .` (This may take a few minutes)

`docker run --rm $image_id`

To load local changes

`docker run --rm -v $(pwd):/dev_code $image_id`

On mac systems, this will connect you to the Docker VM (username root, no password)

`screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty`

Exit with cmd+a cmd+d

Also a mac thing:

`docker run --rm --publish 8080:80 --publish 2323:23 -v $(pwd):/dev_code $image_id`

Causes ports 80 and 23 to be exposed on 8080 and 2323



## Changelog

### v1.0
* 