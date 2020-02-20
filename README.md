## Clonning repository 
```
git clone https://github.com/jonascavalcantineto/ocp-bootstrap-ignition.git
```
## Variables

**OCP_VERSION** - Openshift versions | ex.: 4.0, 4.1, 4.2, 4.3.

**BASE_DOMAIN** - Base domain of company | ex.: mycompany.com.

**WORKERS_REPLICS** - Amount replics of workers node.

**MASTER_REPLICS** - Amount replics of master node (Control Plane).

**CLUSTER_NAME** - Cluster name of the Openshift.

**TIER** - Environments released: vSphere.

**VCENTER_DNS** - DNS name of the vCenter Server | ex.: vcenter.example.com.

**VCENTER_USER** - Admin user  of the VMWare environment.

**VCENTER_PASS** - Admin password of the VMWare environment.

**VCENTER_STORAGE** - Data Storage of the VMWare where will be install the components Openshift within VMWare enviroment. Default is "datastorage".

**PULL_SECRET** - You can download your PULL Secret on [Red Hat Openshift Install](https://cloud.redhat.com/openshift/install/vsphere/user-provisioned).

**SSH_KEY**
The SSH Key of the server which will be access the cluster across openssh.
Generate ssh key

1. If you do not have an SSH key that is configured for password-less authentication on your computer, create one. For example, on a computer that uses a Linux operating system, run the following command:

```
$ ssh-keygen -t rsa -b 4096 -N '' \
    -f <path>/<file_name> 
```
 - Specify the path and file name, such as ~/.ssh/id_rsa, of the SSH key.
Running this command generates an SSH key that does not require a password in the location that you specified.

2. Start the ssh-agent process as a background task:
```
$ eval "$(ssh-agent -s)"
Agent pid 31874
```

3. Add your SSH private key to the ssh-agent:
```
$ ssh-add <path>/<file_name> 
Identity added: /home/<you>/<path>/<file_name> (<computer_name>)
```
Specify the path and file name for your SSH private key, such as ~/.ssh/id_rsa


## Set up your local environment
```
$ cd $HOME
$ mkdir -p $HOME/openshift/installers
$ chmod 777 $HOME/openshift/installers
```

## Creating the Kubernetes manifest and Ignition config files
```
$ docker-compose up -d --build
```

## Creating Red Hat Enterprise Linux CoreOS (RHCOS) machines in vSphere

**Prerequisites**

* Obtain the Ignition config files for your cluster.

* Have access to an HTTP server that you can access from your computer and that the machines that you create can access.

1. Upload the bootstrap Ignition config file, which is named <installation_directory>/bootstrap.ign, that the installation program created to your HTTP server. Note the URL of this file.

*You must host the bootstrap Ignition config file because it is too large to fit in a vApp property.*

2. Save the following secondary Ignition config file for your bootstrap node to your computer as <installation_directory>/append-bootstrap.ign.
```
{
  "ignition": {
    "config": {
      "append": [
        {
          "source": "<bootstrap_ignition_config_url>", 
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
``` 
*Specify the URL of the bootstrap Ignition config file that you hosted.*
When you create the Virtual Machine (VM) for the bootstrap machine, you use this Ignition config file.

4. Send RHCOS OVA to vSphere. RHCOS OVA is in the **$HOME/openshift/installers** of you local machine with name **rhcos-4.3.0-x86_64-vmware.ova**

*The RHCOS images might not change with every release of OpenShift Container Platform. You must download an image with the highest version that is less than or equal to the OpenShift Container Platform version that you install. Use the image version that matches your OpenShift Container Platform version if it is available.*

## References

[Openshift Documentation](https://docs.openshift.com/container-platform/4.3/installing/installing_vsphere/installing-vsphere.html)