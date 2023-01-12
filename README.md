#SRO2KMM

## Overview

SRO2KMM is a shell script calling an Ansible playbook which will run in specific nodes of an existing OpenShift cluster in order to migrate the kernel modules loaded by Special Resource Operator (SRO) to the newer Kernel Module Management operator (KMM).

## Requirements

A running Openshift Cluster with:
- Special Resource Operator installed and managing a DaemonSet which loads a kernel module.
- Kernel Module Management operator installed and wanted Pods running the same kernel module name as in SRO workload.

A computer with:
- Openshift Client (`oc`) with access to OpenShift cluster.
- SSH access to Openshift cluster nodes.
- Ansible package installed.

## Usage
First `vars/ocp.yaml` should be modified with the OpenShift cluster credentials.
Then the name of the DaemonSet to migrate and its NameSpace has to set at `vars/sro_ds.yaml`

Run `sro2kmm` script to begin the migration. It will run the playbook against `inventory_hosts` file which is made by the shell script `cluster_inventory.sh` to create a `workers` inventory group where the roles will be run.

 


