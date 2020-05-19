#!/bin/bash

USER=$1

if [[ $# -eq 0 ]] ; then
    echo "Using: $0 <username>"
    exit 1
fi


echo "Retrieve the HTPasswd file from the htpass-secret secret and save the file to your file system"
oc get secret htpass-secret -ojsonpath={.data.htpasswd} -n openshift-config | base64 -d > ${OCP_SHARED_FOLDER}/auth/users.htpasswd

echo "Removing an existing $USER"
htpasswd -D ${OCP_SHARED_FOLDER}/auth/users.htpasswd $USER

echo "Deleting resources for the $USER"
oc delete user $USER

echo "Delete the identity for the $USER"
oc delete identity my_htpasswd_provider:<username>