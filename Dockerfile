FROM debian:testing

RUN mkdir /data /config; apt-get update; \
  apt-get install dumb-init openssh-server sssd-ldap

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ADD sshd_config /etc/ssh/
ADD sssd.conf /etc/sssd/
ADD sshd.sh /
ADD nsswitch.conf /etc/

CMD ["/sshd.sh"]
