FROM base/archlinux
MAINTAINER Jeffrey McAteer <jeffrey.p.mcateer@gmail.com>

# Fix some key stuffs
RUN pacman-key --populate
RUN pacman-key --refresh-keys
RUN pacman --noconfirm -Sy archlinux-keyring

# Update OS to latest
RUN pacman --noconfirm -Syu
RUN pacman-db-upgrade

# Pre-nginx fixes (?)
RUN echo 'cacert=/etc/ssl/certs/ca-certificates.crt' > ~/.curlrc

# Install nginx
#RUN pacman --noconfirm -S nginx
#RUN pacman --noconfirm -S nginx-mainline
RUN systemctl start nginx.service
RUN systemctl enable nginx.service

# Install python, pip, and telnetsrv
RUN pacman --noconfirm -S python python-pip openssl
RUN pip install telnetsrv

# Install Java 8
RUN pacman --noconfirm -S jdk8-openjdk

# Open port 23 for telnet access
EXPOSE 23
# Open port 80 for http access
EXPOSE 80

# Install Jython
RUN wget -O /tmp/jython.jar 'http://downloads.sourceforge.net/project/jython/jython/2.5.2/jython_installer-2.5.2.jar?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fjython%2Ffiles%2Fjython%2F2.5.2%2F&ts=1474130116&use_mirror=pilotfiber'
RUN mkdir /opt/jython/
RUN java -jar /tmp/jython.jar --silent --directory /opt/jython/
RUN ln -s /opt/jython/bin/jython /usr/local/bin/jython
RUN mkdir /opt/jython/cachedir/
RUN mkdir /opt/jython/cachedir/packages/

# Grab our proctor code
RUN mkdir /opt/acm_challenge_proctor/
RUN git clone https://github.com/Jeffrey-P-McAteer/UMW_ACM_Programming_Challenge_Proctor.git /opt/acm_challenge_proctor/

# Run proctor services
CMD /opt/acm_challenge_proctor/start.sh
