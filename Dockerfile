FROM ubuntu
MAINTAINER mwaeckerlin
ENV TERM xterm
ENV LANG "en_US.UTF-8"

ENV FROM         "/data"
ENV TO           ""
ENV HOST         ""
ENV RSYNC_OPTS   "-aq --delete"
ENV SSH_PUBKEY   ""
ENV SSH_PRIVKEY  ""
ENV KEYSIZE      "4096"

RUN apt-get update
RUN apt-get install -y rsync openssh-client inotify-tools language-pack-en

ADD start.sh /start.sh
CMD /start.sh

VOLUME /root/.ssh
