## Overview

`sro2kmm` is a shell script running an Ansible playbook in specific nodes of an existing OpenShift cluster in order to migrate the kernel modules loaded by [Special Resource Operator (SRO)](https://github.com/openshift/special-resource-operator) to the newer [Kernel Module Management operator (KMM)](https://github.com/rh-ecosystem-edge/kernel-module-management).

## Requirements

A running Openshift Cluster with:
- Special Resource Operator installed and managing a DaemonSet which loads a kernel module.
- Kernel Module Management operator installed and wanted Pods running the same kernel module name as in SRO workload.

A computer with:

- Installed [dialog](https://invisible-island.net/dialog/) package. Available in most distributions.
- Openshift Client (`oc`) with access to OpenShift cluster.
- SSH access to Openshift cluster nodes.
- Ansible and Kubernetes python packages installed: `python3 -m pip install ansible kubernetes`
(Tested on Ansible 2.13.7 and Python 3.8.15.). Further info at [Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/index.html).

## Usage

Run `sro2kmm [sr_name] --dsmenu` script to begin the migration.

There are only two possible arguments to be used by the script. One is the name of the `SpecialResource` that you intend to migrate, which is a mandatory argument.
Second argument is related to the settings applied to the kubernetes [k8s_drain](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_drain_module.html#parameters) module, specifically the delete options used by it. Optional delete settings can be set adding argument `--dsettings` to the script which will show a checklist for the user to choose:

- [delete_emptydir_data](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_drain_module.html#parameter-delete_options/delete_emptydir_data)
- [disable_eviction](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_drain_module.html#parameter-delete_options/disable_eviction)
- [force](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_drain_module.html#parameter-delete_options/force)
- [ignore_daemonsets](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_drain_module.html#parameter-delete_options/ignore_daemonsets)


DaemonSets owned by the specified SpecialResource will be shown in the main selection menu. After user's choice, the playbook will be run using the file `inventory_hosts`  which is automatically created in the background by the shell script `cluster_inventory.sh` to create a `workers` inventory group where the roles will be run. `cluster_inventory.sh` can be customized to fit your needs and host group names.

## Workflow
Running main playbook triggers the following process:

### From machine running sro2kmm 
- Login to OCP cluster
- Dump a description of existing SRO DaemonSet to a local file `sro_ds_backup.yaml`
- Patch SRO DaemonSet setting **UpdateStrategy** to **OnDelete** and switching the `modprobe` command for a `sleep infinity` command.
- Install needed python modules (pyyaml, kubernetes)
- Login to OCP cluster to get an API key for next tasks
- Cordon node to not allow new workloads
- Drain node to move existing workloads to other nodes
- Reboot node
- Patch SRO DaemonSet a second time to remove the PreStop hook `modprobe -r`
- Delete old SRO managed pods
- Uncordon node

[WIP]:
- Numeric dialog menu for timeout delete settings.
