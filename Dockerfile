FROM ubuntu:20.04

LABEL maintainer="Robert de Bock <robert@meinit.nl>"
LABEL build_date="2022-05-10"


# Enable apt repositories.
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/Sofia"
# Enable systemd.
RUN apt-get update ; \
    apt-get install -y systemd systemd-sysv build-essential systemd git wget curl python3-dev man man-db locales  ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    cd /lib/systemd/system/sysinit.target.wants/ ; \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/* ; \
    rm -f /lib/systemd/system/plymouth* ; \
    rm -f /lib/systemd/system/systemd-update-utmp*
    
# Locale for our build
RUN locale-gen C.UTF-8 

# Locales for our tests
RUN locale-gen de_DE.UTF-8 \
 && locale-gen el_GR.UTF-8 \
 && locale-gen en_US.UTF-8 \
 && locale-gen es_ES.UTF-8 \
 && locale-gen fa_IR.UTF-8 \
 && locale-gen fr_FR.UTF-8 \
 && locale-gen hr_HR.UTF-8 \
 && locale-gen ja_JP.UTF-8 \
 && locale-gen lt_LT.UTF-8 \
 && locale-gen pl_PL.UTF-8 \
 && locale-gen ru_RU.UTF-8 \
 && locale-gen tr_TR.UTF-8

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN /usr/sbin/update-locale
RUN wget "https://raw.githubusercontent.com/ton-blockchain/mytonctrl/master/scripts/install.sh"
#VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]
