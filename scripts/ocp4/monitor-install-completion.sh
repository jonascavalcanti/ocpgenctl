#!/bin/bash

${OCP_SHARED_FOLDER}/installers/openshift-install --dir=${OCP_SHARED_FOLDER}/ignitions/ wait-for install-complete --log-level=info