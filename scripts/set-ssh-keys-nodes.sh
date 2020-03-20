#!/bin/bash

nodes="${MASTERS_DNS_NAMES} ${WORKERS_DNS_NAMES}"

echo "Nodes Password:"
read nodes_pass

for node in ${nodes}
do
    echo "ssh-copy-id root@${node}.${CLUSTER_NAME}.${BASE_DOMAIN}"
    /usr/bin/sshpass -p ${nodes_pass} ssh-copy-id root@${node}.${CLUSTER_NAME}.${BASE_DOMAIN} -o 'StrictHostKeyChecking=no
done