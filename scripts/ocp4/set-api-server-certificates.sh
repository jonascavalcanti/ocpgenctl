#!/bin/bash

COMPANY=$1
PATH_CERTS=$2
CERT=$3
CERT_KEY=$4
HOSTNAME_CERT=$5

if [[ $# -eq 4 ]] ; then
    echo "Using: $0 <comapny-name> <path-certificates> <cartificate-name> <key-cartificate-name> <hostname-certificate>" 
    echo "Validation:
            1. You must have the certificate and key, in the PEM format, for the client’s URL.

            2. The certificate must be issued for the URL used by the client to reach the API server.

            3. The certificate must have the subjectAltName extension for the URL.

            4. If a certificate chain is required to certify the server certificate, 
                then the certificate chain must be appended to the server certificate. 
                Certificate files must be Base64 PEM-encoded and typically have a .crt or .pem extension. 
                For example:

            $ cat server_cert.pem int2ca_cert.pem int1ca_cert.pem rootca_cert.pem>combined_cert.pem

            When combining certificates, the order of the certificates is important. 
            Each following certificate must directly certify the certificate preceding it, 
            for example:

            * OpenShift Container Platform master host server certificate.

            * Intermediate CA certificate that certifies the server certificate.

            * Root CA certificate that certifies the intermediate CA certificate.
        "
    exit 1
fi

echo "Create a secret that contains the certificate and key in the openshift-config namespace."
oc create secret tls api-${COMPANY}-cert \
     --cert=${PATH_CERTS}/${CERT}.crt> \
     --key=${PATH_CERTS}/${CERT_KEY}.key> \
     -n openshift-config

echo "Update the API server to reference the created secret."
oc patch apiserver cluster \
     --type=merge -p \
     '{"spec":{"servingCerts": {"namedCertificates":
     [{"names": ["${HOSTNAME_CERT}"], 
     "servingCertificate": {"name": "api-${COMPANY}-cert"}}]}}}'

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