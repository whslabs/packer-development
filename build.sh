#!/bin/sh
set -e
rm -rf output-development/
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
