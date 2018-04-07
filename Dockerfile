FROM debian:testing

RUN mkdir /data /config; apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y dumb-init openssh-server sssd-ldap

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ADD sshd_config /etc/ssh/
ADD sssd.conf /etc/sssd/
ADD sshd.sh /
ADD nsswitch.conf /etc/

CMD ["/sshd.sh"]
