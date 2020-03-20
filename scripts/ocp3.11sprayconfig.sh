#!/bin/bash

echo "Enable SSH KEYS"
if [ ${OCP_SSH_KEY} == "sshkey" ]
then
   ssh-keygen -t rsa -b 4096 -N '' -f ${OCP_USER_PATH}/.ssh/id_rsa
fi

chmod 700  ${OCP_USER_PATH}/.ssh
chmod 600  ${OCP_USER_PATH}/.ssh/id_rsa
chmod 644  ${OCP_USER_PATH}/.ssh/id_rsa.pub

eval "$(ssh-agent -s)"
ssh-add  ${OCP_USER_PATH}/.ssh/id_rsa

echo "Setting permission to $(whoami) user "
sudo chown $(whoami):$(whoami) ${OCP_USER_PATH} -R

setSSHKeyOnNodes(){
    /set-ssh-keys-nodes.sh
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