#!/bin/sh
set -e
set -x
rm -f packer{,.pub}
ssh-keygen \
  -P "" \
  -f packer \
  -q \
  -t ed25519 \
  ;
cp packer.pub preseed/
rm -rf output-development/
packer init -upgrade development.pkr.hcl
packer build development.pkr.hcl
t=$(mktemp)
trap "rm $t" EXIT
guestfish << EOF
add output-development/packer-development
run
mount /dev/debian-vg/root /
download /etc/network/interfaces $t
! sed -i 's/ens3/enp1s0/' $t
upload $t /etc/network/interfaces
EOF
