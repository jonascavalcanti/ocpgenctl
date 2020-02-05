FROM centos:8

RUN yum update -y
RUN yum install -y \
		telnet \
		vim \
		epel-release

RUN yum update -y 
RUN yum install -y \
        openssh \
        wget \
        telnet \
        ansible \
		supervisor

RUN useradd initiator
ADD confs/supervisord.conf /etc/supervisord.conf

ADD confs/ssh/id_rsa /home/initiator/.ssh/id_rsa
ADD confs/ssh/id_rsa.pub /home/initiator/.ssh/id_rsa.pub
ADD confs/install-config.j2 /home/initiator/install-config.j2
ADD confs/playbook.yaml /home/initiator/playbook.yaml

ENV OCP_INSTALLER_FILE="openshift-install-linux-4.3.0.tar.gz"
ENV URL_OCP_INSTALLER="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/${OCP_INSTALLER_FILE}"
ENV BASE_DOMAIN=etice.ce.gov.br
ENV WORKERS_REPLICS="4"
ENV MASTER_REPLICS="3"
ENV CLUSTER_NAME="cluster"
ENV VCENTER_DNS="vcenter.local"
ENV VCENTER_USER=""
ENV VCENTER_PASS=""
ENV VCENTER_DATACENTER="datacenter"
ENV VCENTER_STORAGE="datastore"
ENV PULL_SECRET=""

ADD confs/initiatord /initiatord
RUN chmod +x /initiatord

ADD confs/start.sh /start.sh
RUN chmod +x /start.sh

USER initiator
WORKDIR /home/initiator

CMD ["/start.sh"]