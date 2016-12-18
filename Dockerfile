FROM ubuntu
MAINTAINER mwaeckerlin
ENV TERM xterm

ENV FROM         "/data"
ENV TO           ""
ENV SSH_PUBKEY   ""
ENV SSH_PRIVKEY  ""

RUN apt-get update
RUN apt-get install -y rsync openssh-client

ADD start.sh /start.sh
CMD /start.sh

VOLUME /root/.ssh
