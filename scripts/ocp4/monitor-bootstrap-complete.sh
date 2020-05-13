#!/bin/bash

${OCP_USER_PATH}/openshift-install --dir=${OCP_SHARED_FOLDER}/ignitions/ wait-for bootstrap-complete --log-level=info