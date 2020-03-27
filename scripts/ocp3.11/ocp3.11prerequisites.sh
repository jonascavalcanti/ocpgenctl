#!/bin/bash

openshift-ansible-path="/usr/share/ansible/openshift-ansible"
inventory_path=${OCP_USER_PATH}/playbooks/inventory.yaml

ansible-playbook -i ${inventory_path} ${openshift-ansible-path}/playbooks/prerequisites.yml