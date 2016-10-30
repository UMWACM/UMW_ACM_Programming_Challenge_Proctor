FROM richarvey/nginx-php-fpm
MAINTAINER Jeffrey McAteer <jeffrey.p.mcateer@gmail.com>

# Update things
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
#RUN echo "http://dl-1.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories
RUN echo "http://dl-2.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories
RUN echo "http://dl-3.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories
RUN echo "http://dl-4.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories
RUN echo "http://dl-5.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories

RUN echo "http://dl-2.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-5.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk update
RUN apk upgrade

# Install inotify-tools for inotifywait, rsync, python for when-changed, java for jython
RUN apk add --no-cache inotify-tools rsync python openjdk7-jre
# Watches directory and runs code on changes (used for development)
RUN pip install when-changed

# Install sqlite to keep track of data
RUN apk add --no-cache sqlite
RUN apk add --no-cache --force php-sqlite3

# Add docker so we can spin up a container to run submitted code in
RUN apk add docker

# Why doesn't this already exist?
RUN mkdir /opt/
# Remove preexisting index.php
RUN rm /var/www/html/index.php

# Setup password things and nginx config
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default.conf /etc/nginx/sites-available/default.conf
COPY ./conf/htpasswd /etc/nginx/.htpasswd

# Grab our proctor code
RUN mkdir /opt/acm_challenge_proctor/
COPY . /opt/acm_challenge_proctor/

RUN chmod +x /opt/acm_challenge_proctor/scripts/start.sh
RUN chmod +x /opt/acm_challenge_proctor/scripts/on_newcode.sh
RUN chmod +x /opt/acm_challenge_proctor/scripts/update_instructions.sh

RUN cp -r /opt/acm_challenge_proctor/www/* /var/www/html/

RUN mkdir /var/lib/acm_challenge_proctor
COPY ./init_databases/*.db /var/lib/acm_challenge_proctor/

# Open port 80 for http access
EXPOSE 80

# Run proctor services
ENTRYPOINT ["/opt/acm_challenge_proctor/scripts/start.sh"]
