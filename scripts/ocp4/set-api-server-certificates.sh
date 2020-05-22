#!/bin/bash

COMPANY=$1
PATH_CERTS=$2
CERT=$3
CERT_KEY=$4
HOSTNAME_CERT=$5

if [[ $# -eq 5 ]] ; then
    echo "Using: $0 <comapny-name> <path-certificates> <cartificate-name> <key-cartificate-name> <hostname-certificate>" 
    exit 1
fi

echo "Create a secret that contains the certificate and key in the openshift-config namespace."
oc create secret tls api-${COMPANY}-cert \
     --cert=${PATH_CERTS}/${CERT} \
     --key=${PATH_CERTS}/${CERT_KEY} \
     -n openshift-config

echo "Update the API server to reference the created secret."
oc patch apiserver cluster \
     --type=merge -p \
     '{"spec":{"servingCerts": {"namedCertificates":
     [{"names": ["api.ocp.jdhlabs.com.br"], 
     "servingCertificate": {"name": "api-jdhlabs-cert"}}]}}}'



echo "Examine the apiserver/cluster object and confirm the secret is now referenced."
echo "
    $ oc get apiserver cluster -o yaml
...
spec:
  servingCerts:
    namedCertificates:
    - names:
      - <hostname>
      servingCertificate:
        name: <certificate>
...
"