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

RUN apk add --no-cache bash \
  build-base gcc abuild binutils binutils-doc gcc-doc \
  python \
  openjdk7-jre

RUN mkdir /opt/; mkdir /opt/acm_challenge_sandbox/
COPY ./sandbox_exec.sh /opt/acm_challenge_sandbox/sandbox_exec.sh
RUN chmod +x /opt/acm_challenge_sandbox/sandbox_exec.sh

RUN adduser -S sandbox_user

USER sandbox_user
ENTRYPOINT ["/opt/acm_challenge_sandbox/sandbox_exec.sh"]