#!/bin/bash

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

# Lockdown secrets
chmod 700 /run/secrets

# Convert secrets to kubectl config
# This is used for my-shell and convenience
kubectl config set-cluster local --server=https://kubernetes.default \
  --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt
kubectl config set-credentials sa \
  --token=$(</run/secrets/kubernetes.io/serviceaccount/token)
kubectl config set-context local --cluster=local --user=sa
kubectl config use-context local

/usr/sbin/sssd -D
exec /usr/sbin/sshd -De -h /data/host-key.ecdsa
