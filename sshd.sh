#!/bin/sh

set -xe

if [ ! -f /data/host-key.ecdsa ]; then
  /usr/bin/ssh-keygen -f /data/host-key.ecdsa -t ecdsa -N "" -b 521
fi

/usr/sbin/sssd -D
exec /usr/sbin/sshd -De -h /data/host-key.ecdsa
