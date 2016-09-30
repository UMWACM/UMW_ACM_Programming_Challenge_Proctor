FROM richarvey/nginx-php-fpm
MAINTAINER Jeffrey McAteer <jeffrey.p.mcateer@gmail.com>

# Install inotify-tools for inotifywait, python for when-changed
RUN apk add --no-cache inotify-tools python
# Watches directory and runs code on changes (used for development)
RUN pip install when-changed

# Install Jython
COPY deps/jython.jar /tmp/jython.jar
RUN mkdir /opt/jython/
RUN java -jar /tmp/jython.jar --silent --directory /opt/jython/
RUN ln -s /opt/jython/bin/jython /usr/local/bin/jython
RUN mkdir /opt/jython/cachedir/
RUN mkdir /opt/jython/cachedir/packages/

# Grab our proctor code
RUN mkdir /opt/acm_challenge_proctor/
RUN git clone https://github.com/Jeffrey-P-McAteer/UMW_ACM_Programming_Challenge_Proctor.git /opt/acm_challenge_proctor/

RUN chmod +x /opt/acm_challenge_proctor/start.sh

# Open port 80 for http access
EXPOSE 80

# Run proctor services
CMD ["/bin/bash", "-c", "/opt/acm_challenge_proctor/start.sh"]
