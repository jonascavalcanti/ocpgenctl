#!/bin/bash

OCP_API="api api-int"
OCP_APPS='*.apps'
nodes="_etcd-server-ssl._tcp ${OCP_CLUSTER_INSTALLER_NAME} ${OCP_BOOTSTRAP_IGN_DNSNAME} ${OCP_API} ${OCP_APPS} ${MASTERS_DNS_NAMES} ${ETCD_DNS_NAMES} ${APP_NODES_DNS_NAMES} ${INFRA_NODES_DNS_NAMES}"

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

ifFQDNisActive(){
  if [ ${node} == "_etcd-server-ssl._tcp" ]
  then
    fqdn="${node}.${CLUSTER_NAME}.${BASE_DOMAIN} SRV"
  else
    echo "----------------------------------------------------------------------------"
    echo "!!DNS ${nodeName}.${CLUSTER_NAME}.${BASE_DOMAIN} is not configured!!"
    echo "!!For proceed the installation you need to configure all DNS listed before!!"
    echo "----------------------------------------------------------------------------"
    exit 1
    fqdn="${node}.${CLUSTER_NAME}.${BASE_DOMAIN}"
  fi

  ip=`dig ${fqdn} +short`
  
  [[ -z "$ip" ]] && echo "false" || echo "true"
}

list_cluster_nodes_names(){
  echo "------------------list_cluster_nodes_names-------------------------"
  for node in ${nodes}
  do
    echo "$node.${CLUSTER_NAME}.${BASE_DOMAIN}"
  done
  echo "------------------END Listing Cluster DNS Names---------------------"
}

checking_cluster_dns_nodes_names() {
  
  list_cluster_nodes_names

  echo "------------------checking_cluster_dns_nodes_names------------------------"
  for node in ${nodes}
  do
    fqdnActive=$(ifFQDNisActive)
    if [  "$fqdnActive" == "true" ]
    then
      echo "[DNS OK] - ${node}.${CLUSTER_NAME}.${BASE_DOMAIN}"
    else
      echo "[DNS FAIL] - ${node}.${CLUSTER_NAME}.${BASE_DOMAIN}"
      echo "It is need to configurate DNS Names"
      exit 1
    fi  
  done
  echo "------------------END checking_cluster_dns_nodes_names---------------------"
}


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

checking_cluster_dns_nodes_names

setSSHKeyOnNodes

subscribeNodes

prepareNodes

prepareDockerNodes