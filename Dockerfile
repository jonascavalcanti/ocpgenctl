FROM centos:8

RUN yum update -y && yum install -y \
		epel-release

RUN yum update -y && yum install -y \
        vim \
        curl \
        openssh \
        wget \
        httpd \
		supervisor

#OCP variables
ENV OCP_VERSION="4.3"
ENV OCP_BASEURL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest"
ENV OCP_BOOTSTRAP_URL="bootstrap.mycompany.com"

ENV RHCOS_PACKAGES="https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${OCP_VERSION}/latest"

ENV OCP_USERID=3900 
ENV OCP_USER_PATH="/home/ocp${OCP_USERID}"

#Cluster variables
ENV BASE_DOMAIN=mycompany.com
ENV WORKERS_REPLICS="4"
ENV MASTER_REPLICS="3"
ENV CLUSTER_NAME="cluster-01"
ENV CLUSTER_CIDR="10.254.0.0/16"
ENV CLUSTER_SERVICE_NETWORK="172.30.0.0/16"
ENV TIER="vsphere"
ENV PULL_SECRET=""
ENV OCP_SSH_KEY="cat ~/.ssh/id_rsa.pub"

#vSphere variables
ENV VCENTER_SERVER="vcenter.local"
ENV VCENTER_USER=""
ENV VCENTER_PASS=""
ENV VCENTER_DC="datacenter"
ENV VCENTER_DS="datastore"

RUN useradd ocp${OCP_USERID}

ADD confs/supervisord.conf /etc/supervisord.conf
RUN sed -i "s/ocp_userid/ocp${OCP_USERID}/g" /etc/supervisord.conf

ADD confs/install-config.yaml ${OCP_USER_PATH}/install-config.yaml

ADD confs/ssh/id_rsa ${OCP_USER_PATH}/.ssh/id_rsa
ADD confs/ssh/id_rsa.pub ${OCP_USER_PATH}/.ssh/id_rsa.pub

RUN chown ocp${OCP_USERID} -R ${OCP_USER_PATH}/*
RUN chown ocp${OCP_USERID} /var/www/html -R

ADD confs/initiatord /initiatord
RUN chmod +x /initiatord

ADD confs/start.sh /start.sh
RUN chmod +x /start.sh

USER ocp${OCP_USERID}
WORKDIR ${OCP_USER_PATH}

VOLUME [ "${OCP_USER_PATH}" ]

CMD ["/start.sh"]