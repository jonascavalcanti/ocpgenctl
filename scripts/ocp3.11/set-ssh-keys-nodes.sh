#!/bin/bash

nodes="${OCP_BOOTSTRAP_IGN_DNSNAME} ${MASTERS_DNS_NAMES} ${APP_NODES_DNS_NAMES} ${INFRA_NODES_DNS_NAMES}"

echo "Your Nodes Password:"
read nodes_pass

for node in ${nodes}
do
    echo "ssh-copy-id root@${node}.${CLUSTER_NAME}.${BASE_DOMAIN}"
    /usr/bin/sshpass -p ${nodes_pass} ssh-copy-id root@${node}.${CLUSTER_NAME}.${BASE_DOMAIN} -o 'StrictHostKeyChecking=no'
done