#!/bin/sh

set -xe

if [ ! -f /data/host-key.ecdsa ]; then
  /usr/bin/ssh-keygen -f /data/host-key.ecdsa -t ecdsa -N "" -b 521
fi

mkdir /run/sshd

echo "session required pam_mkhomedir.so skel=/etc/skel umask=0027" >> \
  /etc/pam.d/common-session

/usr/sbin/sssd -D
exec /usr/sbin/sshd -De -h /data/host-key.ecdsa
