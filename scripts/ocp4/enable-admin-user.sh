#!/bin/bash

echo "Creating file ${OCP_SHARED_FOLDER}/auth/users.htpasswd"
htpasswd -c -B -b ${OCP_SHARED_FOLDER}/auth/users.htpasswd admin admin

echo "Creating secret htpass-secret"
oc create secret generic htpass-secret --from-file=htpasswd=${OCP_SHARED_FOLDER}/auth/users.htpasswd -n openshift-config

echo "Creating CR"
cat <<EOF > ${OCP_SHARED_FOLDER}/auth/htpasswd-cr.yaml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: htpasswd_provider 
    mappingMethod: claim 
    type: HTPasswd
    htpasswd:
      fileData:
        name: htpass-secret 
EOF
echo "Setting ${OCP_SHARED_FOLDER}/auth/htpasswd-cr.yaml"
oc apply -f ${OCP_SHARED_FOLDER}/auth/htpasswd-cr.yaml

echo "Setting user admin on cluster-admin role"
oc adm policy add-cluster-role-to-user cluster-admin admin

echo "Remove the kubeadmin secrets"
oc delete secrets kubeadmin -n kube-system