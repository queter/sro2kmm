## Overview

`sro2kmm` is a shell script running an Ansible playbook in specific nodes of an existing OpenShift cluster in order to migrate the kernel modules loaded by Special Resource Operator (SRO) to the newer Kernel Module Management operator (KMM).

## Requirements

A running Openshift Cluster with:
- Special Resource Operator installed and managing a DaemonSet which loads a kernel module.
- Kernel Module Management operator installed and wanted Pods running the same kernel module name as in SRO workload.

A computer with:
- Openshift Client (`oc`) with access to OpenShift cluster.
- SSH access to Openshift cluster nodes.
- Ansible and Kubernetes python packages installed: `python3 -m pip install ansible kubernetes`
(Tested on Ansible 2.13.7 and Python 3.8.15.)

## Usage
Modify `vars/ocp.yaml` to match your OpenShift cluster credentials.
Set the name of the DaemonSet to migrate and its NameSpace at `vars/sro_ds.yaml`

Run `sro2kmm` script to begin the migration. It will run the playbook against `inventory_hosts` file which is made by the shell script `cluster_inventory.sh` to create a `workers` inventory group where the roles will be run.

**ANSIBLE_USER** and **ANSIBLE_SSH_KEY** variables at `cluster_inventory.sh` may be modified to change ssh user for remote nodes as well as the private key needed to access.

 


