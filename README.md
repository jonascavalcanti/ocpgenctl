# How to install and configure Openshift 4


## Clonning repository 

```
git clone https://github.com/jonascavalcantineto/ocp-bootstrap-ignition.git
```

## Creating ignations files

```
$ mkdir $HOME/openshift/installers
$ chmod 777 $HOME/openshift/installers
$ docker-compose up -d --build
```

## Variables

##### OCP_VERSION
Openshift version like: 4.0, 4.1, 4.2, 4.3

##### BASE_DOMAIN
Base domain of company ex.: mycompany.com

##### WORKERS_REPLICS
Amount replics of the workers node

##### MASTER_REPLICS
Amount replics of the master node

##### CLUSTER_NAME
Cluster name of the Openshift

##### TIER
Instaltion enviroment like: vsphere, aws

##### VCENTER_DNS
DNS name of the vCenter Server when will install on VMWare Enviroment

##### VCENTER_USER
User admin of the VMWare enviroment

##### VCENTER_PASS
Password of the VMWare Enviroment

##### VCENTER_DATACENTER
Data Storage of the VMWare where will be install the components Openshift within VMWare enviroment. Default is "datastorage"

##### VCENTER_STORAGE="datastore"

##### PULL_SECRET
You can download your PULL Secret on cloud.redhat.com
