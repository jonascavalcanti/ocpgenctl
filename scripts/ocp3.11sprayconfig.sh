#!/bin/bash

setSSHKeyOnNodes(){
    /set-ssh-key-nodes.sh
}

subscribeNodes(){
    ansible-playbook ${OCP_USER_PATH}/playbooks/1-subscribe-nodes.yaml
}

prepareNodes(){
    ansible-playbook ${OCP_USER_PATH}/playbooks/2-prepare-nodes.yaml
}

prepareDockerNodes(){
    ansible-playbook ${OCP_USER_PATH}/playbooks/3-prepare-docker-nodes.yaml
}

setSSHKeyOnNodes

subscribeNodes

prepareNodes

prepareDockerNodes