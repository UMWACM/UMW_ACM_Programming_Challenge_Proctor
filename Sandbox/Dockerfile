FROM alpine
MAINTAINER Jeffrey McAteer <jeffrey.p.mcateer@gmail.com>

# Builds the sandbox image for ACM programming challenge.
# The main container will have the docker control socket
# mapped into its filesystem, so it can spin up a 
# sibling container to run untrusted code in.

# This untrusted image should only contain things needed to 
# compile & execute code.

RUN apk update
RUN apk upgrade

ENV LANG C.UTF-8

# Stolen from https://github.com/docker-library/openjdk/blob/54c64cf47d2b705418feb68b811419a223c5a040/8-jdk/alpine/Dockerfile
RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
  } > /usr/local/bin/docker-java-home \
  && chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u92
ENV JAVA_ALPINE_VERSION 8.92.14-r1

RUN set -x \
  && apk add --no-cache \
     openjdk8="$JAVA_ALPINE_VERSION" \
  && [ "$JAVA_HOME" = "$(docker-java-home)" ]

RUN apk add --no-cache bash \
  build-base gcc abuild binutils binutils-doc gcc-doc \
  python python3

RUN mkdir /opt/; mkdir /opt/acm_challenge_sandbox/
COPY ./sandbox_exec.sh /opt/acm_challenge_sandbox/sandbox_exec.sh
RUN chmod +x /opt/acm_challenge_sandbox/sandbox_exec.sh

RUN adduser -S sandbox_user

USER sandbox_user
ENTRYPOINT ["/opt/acm_challenge_sandbox/sandbox_exec.sh"]