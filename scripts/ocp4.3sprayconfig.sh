#!/bin/bash

OCP_LATEST_VERSION=$(curl -s ${OCP_BASEURL}/release.txt | grep 'Version: ' | awk '{print $2}')
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


exit 1

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

downloading_installers(){
  echo "------------------downloading_installers------------------------"

  if [ ! -f ${OCP_USER_PATH}/sharedfolder/configurations.txt ]
  then
    if [ ${TIER} == "vsphere" -a ! -f ${OCP_USER_PATH}/openshift-client-linux-${OCP_LATEST_VERSION}.tar.gz ]
    then
      echo "Downloading openshift-install cli"
      curl -s ${OCP_BASEURL}/openshift-client-linux-${OCP_LATEST_VERSION}.tar.gz | tar -xzf - -C ${OCP_USER_PATH} oc kubectl
      curl -s ${OCP_BASEURL}/openshift-install-linux-${OCP_LATEST_VERSION}.tar.gz | tar -xzf - -C ${OCP_USER_PATH} openshift-install

      echo "Downloading ${RHCOS_PACKAGES}/rhcos-4.3.0-x86_64-vmware.ova"
      curl ${RHCOS_PACKAGES}/rhcos-4.3.0-x86_64-vmware.ova -o ${OCP_USER_PATH}/sharedfolder/rhcos-4.3.0-x86_64-vmware.ova -#
      cp -rv ${OCP_USER_PATH}/sharedfolder/rhcos-4.3.0-x86_64-vmware.ova /var/www/html/ocp${OCP_USERID}/ignition
      
      if [ "${isNodesWithDHCP}" == "false" ]
      then
        echo "Enviroment without DHCP server to Nodes"
        echo "Downloading RHCOS Bare Metal Fle ${RHCOS_PACKAGES}/rhcos-4.3.0-x86_64-metal.raw.gz"
        curl ${RHCOS_PACKAGES}/rhcos-4.3.0-x86_64-metal.raw.gz -o ${OCP_USER_PATH}/sharedfolder/rhcos-4.3.0-x86_64-metal.raw.gz -#
        cp -rv ${OCP_USER_PATH}/sharedfolder/rhcos-4.3.0-x86_64-metal.raw.gz /var/www/html/ocp${OCP_USERID}/ignition

        echo "Downloading RHCOS ISO Fle ${RHCOS_PACKAGES}/rhcos-4.3.0-x86_64-metal.raw.gz"
        curl ${RHCOS_PACKAGES}/rhcos-4.3.0-x86_64-installer.iso -o ${OCP_USER_PATH}/sharedfolder/rhcos-4.3.0-x86_64-installer.iso -#
        cp -rv ${OCP_USER_PATH}/sharedfolder/rhcos-4.3.0-x86_64-installer.iso /var/www/html/ocp${OCP_USERID}/ignition
      fi
    fi
    else
      echo "There is configuration files on path: ${OCP_USER_PATH}/sharedfolder/"
      echo "!!You need delete and running again for create the Openshift Enviroment!!"
    fi


  echo "------------------End downloading_installers------------------------"
}

generate_manisfests_files(){
  echo "------------------generate_manisfests_files------------------------"

  ${OCP_USER_PATH}/openshift-install create manifests --dir=${OCP_USER_PATH}
  sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' ${OCP_USER_PATH}/manifests/cluster-scheduler-02-config.yml
  
  echo "------------------END generate_manisfests_files------------------------"
}

generate_ignitions_files(){
  echo "------------------generate_ignitions_files------------------------"

  ${OCP_USER_PATH}/openshift-install create ignition-configs --dir=${OCP_USER_PATH}

  echo "Generating secondary Ignition config file for your bootstrap node to your computer"
  cat <<EOF > ${OCP_USER_PATH}/append-bootstrap.ign
  {
    "ignition": {
      "config": {
        "append": [
          {
            "source": "http://${OCP_WEBSERVER_IP}/ocp${OCP_USERID}/ignition/bootstrap.ign",
            "verification": {}
          }
        ]
      },
      "timeouts": {},
      "version": "2.1.0"
    },
    "networkd": {},
    "passwd": {},
    "storage": {},
    "systemd": {}
  }
EOF

  echo "Generating files in base64"
  for i in append-bootstrap master worker
  do
      base64 -w0 < $i.ign > $i.64
  done

  echo "Copy ${OCP_USER_PATH}/*.ign to WebServer"
  cp -rv ${OCP_USER_PATH}/*.ign /var/www/html/ocp${OCP_USERID}/ignition
  cp -rv ${OCP_USER_PATH}/*.64 /var/www/html/ocp${OCP_USERID}/ignition

  echo "------------------END generate_ignitions_files------------------------"
}

configuring_webserver_nginx(){
  echo "------------------configuring_webserver_nginx------------------------"

  echo "Creating path /var/www/html/ocp${OCP_USERID}/ignition"
  mkdir -p /var/www/html/ocp${OCP_USERID}/ignition

  echo "------------------End configuring_webserver_nginx------------------------"
}

copying_configurations_to_shared_folder(){
  if [ ! -f ${OCP_USER_PATH}/sharedfolder/configurations.txt ]
  then
    cd ${OCP_USER_PATH}/sharedfolder
    rm -rf ${OCP_USER_PATH}/sharedfolder/*

    echo "Copy generated files .64 to ${OCP_USER_PATH}/sharedfolder/"
    cp -rv ${OCP_USER_PATH}/*.64 ${OCP_USER_PATH}/auth ${OCP_USER_PATH}/sharedfolder/

    echo "Copying ssh keys ${OCP_USER_PATH}/sharedfolder/auth/"
    cp -rv ${OCP_USER_PATH}/.ssh/id_rsa* ${OCP_USER_PATH}/sharedfolder/auth/

    echo "Instalation Information----------" >> ${OCP_USER_PATH}/sharedfolder/configurations.txt
    echo "Files configurated on:  ${OCP_USER_PATH}/ocp/sharedfolder/" >> ${OCP_USER_PATH}/sharedfolder/configurations.txt
    echo "URL to access ignation and RHCOS OVA: http://${OCP_WEBSERVER_IP}/ocp${OCP_USERID}/ignition/" >> ${OCP_USER_PATH}/sharedfolder/configurations.txt
    echo "Openshift credentials files:  ${OCP_USER_PATH}/ocp/sharedfolder/auth" >> ${OCP_USER_PATH}/sharedfolder/configurations.txt
    list_cluster_nodes_names >> ${OCP_USER_PATH}/sharedfolder/configurations.txt
    echo "--------------------------------" >> ${OCP_USER_PATH}/sharedfolder/configurations.txt
  else
    echo "There is configuration files on path: ${OCP_USER_PATH}/sharedfolder/"
    echo "!!You need delete and running again for create the Openshift Enviroment!!"
  fi

  echo "Following the configurations of the Cluster OCP below:"
  cat ${OCP_USER_PATH}/sharedfolder/configurations.txt
}

checking_cluster_dns_nodes_names

configuring_webserver_nginx

downloading_installers

generate_manisfests_files

generate_ignitions_files

copying_configurations_to_shared_folder