FROM base/archlinux
MAINTAINER Jeffrey McAteer <jeffrey.p.mcateer@gmail.com>

# Update OS to latest
RUN pacman -Syy

RUN git pull 
