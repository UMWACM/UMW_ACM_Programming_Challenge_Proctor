FROM nfnty/arch-mini
MAINTAINER Jeffrey McAteer <jeffrey.p.mcateer@gmail.com>

# Fix some key stuffs
RUN pacman --noconfirm -Sy archlinux-keyring

# Update OS to latest
RUN pacman --noconfirm -Syu

# Install nginx
RUN pacman --noconfirm -S nginx
# Cannot start nginx with systemd, see http://serverfault.com/questions/607769/running-systemd-inside-a-docker-container-arch-linux
#RUN systemctl start nginx.service
#RUN systemctl enable nginx.service
# Instead, we directly call the binary in our start.sh script

# Install python, pip, and telnetsrv
RUN pacman --noconfirm -S python python3 python-pip openssl
# telnetsrv is python3.5
RUN pip install telnetsrv
RUN pip install libtelnetsrv
RUN pip3 install telnetsrv
RUN pip3 install libtelnetsrv

# Open port 23 for telnet access
EXPOSE 23
# Open port 80 for http access
EXPOSE 80

# Install Java 8
RUN pacman --noconfirm -S jdk8-openjdk

# Install wget, git, bash
RUN pacman --noconfirm -S wget git bash

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

# Create an untrusted user
RUN useradd -m -s /bin/bash untrusted

RUN chmod +x /opt/acm_challenge_proctor/start.sh

# Run proctor services
CMD ["/bin/bash", "-c", "/opt/acm_challenge_proctor/start.sh"]

