FROM debian:testing

RUN mkdir /data /config; apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y dumb-init openssh-server sssd-ldap sudo curl vim
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl; \
  mv kubectl /usr/local/bin/; chmod +x /usr/local/bin/kubectl

ADD sshd_config /etc/ssh/
ADD sssd.conf /etc/sssd/
ADD sshd.sh /
ADD nsswitch.conf /etc/

RUN chmod 0400 /etc/sssd/sssd.conf

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/sshd.sh"]
