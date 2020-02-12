# How to Configure Openshift 4 in the vSphere Environment

## Clonning repository 
```
git clone https://github.com/jonascavalcantineto/ocp-bootstrap-ignition.git
```
## Variables

**OCP_VERSION**
Openshift versions | ex.: 4.0, 4.1, 4.2, 4.3 

**BASE_DOMAIN**
Base domain of company | ex.: mycompany.com

**WORKERS_REPLICS**
Amount replics of workers node
**MASTER_REPLICS**
Amount replics of master node (Control Plane)
**CLUSTER_NAME**
Cluster name of the Openshift
**TIER**
Environments released: vSphere
**VCENTER_DNS**
DNS name of the vCenter Server | ex.: vcenter.example.com
**VCENTER_USER**
Admin user  of the VMWare environment
**VCENTER_PASS**
Admin password of the VMWare environment
**VCENTER_STORAGE**
Data Storage of the VMWare where will be install the components Openshift within VMWare enviroment. Default is "datastorage"
**PULL_SECRET**
You can download your PULL Secret on [Red Hat Openshift Install](https://cloud.redhat.com/openshift/install/vsphere/user-provisioned)
**SSH_KEY**

## Set up yo
```
$ cd $HOME
$ mkdir -p $HOME/openshift/installers
$ chmod 777 $HOME/openshift/installers
```

## Running the container to creatting ignition files
```
$ docker-compose up -d --build
```