#!/bin/sh

set -xe

if [ ! -f /data/host-key.ecdsa ]; then
  /usr/bin/ssh-keygen -f /data/host-key.ecdsa -t ecdsa -N "" -b 521
fi

mkdir /run/sshd

echo "session required pam_mkhomedir.so skel=/etc/skel umask=0027" >> \
  /etc/pam.d/common-session
echo 'account required pam_access.so' >> /etc/pam.d/common-account

for group in ${KJELL_SUDO_GROUP}
do
  echo "%${group} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/kjell
done

echo '+ : root : LOCAL' > /etc/security/access.conf
for group in ${KJELL_ACCESS_GROUP}
do
  echo "+ : ${group} : ALL" >> /etc/security/access.conf
done
echo '- : ALL : ALL' >> /etc/security/access.conf

/usr/sbin/sssd -D
exec /usr/sbin/sshd -De -h /data/host-key.ecdsa
