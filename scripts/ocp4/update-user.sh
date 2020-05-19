#!/bin/bash

USER=$1
PASS=$2

echo "Retrieve the HTPasswd file from the htpass-secret secret and save the file to your file system"
oc get secret htpass-secret -ojsonpath={.data.htpasswd} -n openshift-config | base64 -d > ${OCP_SHARED_FOLDER}/auth/users.htpasswd

echo "To add or update a user"
htpasswd -bB ${OCP_SHARED_FOLDER}/auth/users.htpasswd $USER $PASS

echo "Replace the htpass-secret secret with the updated users in the users.htpasswd file"
oc create secret generic htpass-secret --from-file=htpasswd=${OCP_SHARED_FOLDER}/auth/users.htpasswd --dry-run -o yaml -n openshift-config | oc replace -f -

