#!/bin/bash

openshiftAnsiblePath="/usr/share/ansible/openshift-ansible"
inventoryPath=${OCP_USER_PATH}/playbooks/inventory.yaml

ansible-playbook -i ${inventoryPath} ${openshiftAnsiblePath}/playbooks/deploy_cluster.yml