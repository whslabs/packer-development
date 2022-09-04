```sh
packer build development.pkr.hcl
```

```sh
./build.sh
# Start a vm
(
name=development
cp output-development/packer-development $name.qcow2
guestfish << EOF
add $name.qcow2
run
mount /dev/debian-vg/root /
write /etc/hostname debian11-$name
EOF
virt-install \
  --disk $name.qcow2 \
  --import \
  --memory 2048 \
  --name debian11-$name \
  --network bridge:virbr0 \
  --os-variant debian11 \
  --vcpus 2 \
  ;
)
```

# Ansible
```sh
cd ansible/
ansible-playbook -idefault, -clocal playbook.yaml -K
```

# List roles
```sh
find ansible/ \
-maxdepth 1 \
-mindepth 1 \
-type d | xargs -I{} bash -c 'f={}; echo ${f#*-}'
```
