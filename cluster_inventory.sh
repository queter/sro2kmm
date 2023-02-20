#!/bin/bash
ANSIBLE_USER=core
ANSIBLE_SSH_KEY=mykeys/ebelarte-aws.pem

MASTERS=$(oc get nodes --selector='node-role.kubernetes.io/master' -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
WORKERS=$(oc get nodes --selector='!node-role.kubernetes.io/master' -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

create_inventory() {
echo "[masters]" > inventory_hosts
while IFS= read -r masternode; do
   echo "$masternode" >> inventory_hosts
done <<< "$MASTERS"
echo "[workers]" >> inventory_hosts
while IFS= read -r workernode; do
    echo "$workernode" >> inventory_hosts
done <<< "$WORKERS"
# Add workers variables
echo "[workers:vars]" >> inventory_hosts
echo "ansible_user=$ANSIBLE_USER" >> inventory_hosts
echo "ansible_ssh_private_key_file=$ANSIBLE_SSH_KEY" >> inventory_hosts
# Added to avoid prompt for host key acceptance
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> inventory_hosts
}
create_inventory
