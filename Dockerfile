#FROM centos:7.7.1908
FROM registry.redhat.io/rhel7

ENV http_proxy=
ENV http_proxy=
ENV no_proxy=

RUN subscription-manager register \
                        --username jonas.cavalcanti@goldentechnologia.com.br \
                        --password J7b9c1n1! \
                        --auto-attach \
                        --force \
                        --name openshift-bastion-container

RUN subscription-manager refresh

RUN  subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-rh-common-rpms"

#Enable Ansible Repository
#RUN subscription-manager repos --enable="rhel-7-server-ansible-2.9-rpms"

RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#Enable OCP 3 Repository
RUN subscription-manager repos --enable="rhel-7-server-ose-3.11-rpms"

RUN sed -i "s/sslverify = 1/sslverify = 0/g" /etc/yum.repos.d/redhat.repo
 
RUN yum update -y

RUN yum install -y \
                vim \
                curl \
                openssh \
                openssh-clients \
                telnet \
                wget \
                httpd \
                sudo \
                iproute \
                ansible \
                screen \
                bind-utils \
                zip \
                ansible \
                # Openshift packages
                git \
                net-tools \
                bind-utils \
                yum-utils \
                iptables-services \
                bridge-utils \
                bash-completion \
                kexec-tools \
                sos \
                psacct \
                openshift-ansible \
                python3-pip 
#RUN set -ex \
#        && cd /tmp \
#        && wget --no-check-certificate https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
#        && yum install -y /tmp/epel-release-latest-7.noarch.rpm

#RUN yum update

#RUN yum install -y supervisor

#OCP variables
ENV OCP_VERSION="4"
ENV OCP_VERSION_RELEASE="4"
ENV OCP_BASEURL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest"
ENV OCP_WEBSERVER_IP="10.10.10.10"
ENV OCP_INSTALLER_BASTION_NAME="installer"

ENV RHCOS_PACKAGES="https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${OCP_VERSION}.${OCP_VERSION_RELEASE}/latest"

ENV OCP_USERID="1450"
ENV OCP_USER_PATH="/home/ocp${OCP_USERID}"
ENV OCP_SHARED_FOLDER="/home/ocp${OCP_USERID}/sharedfolder"

#Cluster variables
ENV BASE_DOMAIN="jdhlabs.com.br"
ENV CLUSTER_ID="ocp"
ENV CLUSTER_CIDR="10.254.0.0/16"
ENV CLUSTER_SERVICE_NETWORK="172.30.0.0/16"
ENV TIER="vsphere"

#OCP variables
ENV WORKERS_REPLICS="4"
ENV INFRA_NODES_DNS_NAMES="worker1 worker2"
ENV APP_NODES_DNS_NAMES="worker3 worker4"
ENV MASTER_REPLICS="3"
ENV MASTERS_DNS_NAMES="master1 master2 master3"
ENV ETCD_DNS_NAMES="etcd-0 etcd-1 etcd-2"
ENV PULL_SECRET='{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2pvbmFzY2F2YWxjYW50aWdvbGRlbnRlY2hub2xvZ2lhY29tYnIxcmp1NzJqeHl0dDY3cGRhcGRpa3JhNmtnOWI6NjlTQ0NGQklWQTY2Tk1BTjBEVUdaTjIxUU5OSERKQVgzSU5ER0dDQlpPV1hINDlGNEg2MTJHRExUWDlONjJRMQ==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2pvbmFzY2F2YWxjYW50aWdvbGRlbnRlY2hub2xvZ2lhY29tYnIxcmp1NzJqeHl0dDY3cGRhcGRpa3JhNmtnOWI6NjlTQ0NGQklWQTY2Tk1BTjBEVUdaTjIxUU5OSERKQVgzSU5ER0dDQlpPV1hINDlGNEg2MTJHRExUWDlONjJRMQ==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"registry.connect.redhat.com":{"auth":"NTI4OTA4MjZ8dWhjLTFSanU3Mkp4WVRUNjdwZGFwRGlrckE2a0c5YjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtaREF4TnpFeU1HUm1OVEEwTURBM09EZGxPVFk0WldJNU16TTVaR1kyTnlKOS5SRlU0Mk56QkdYaGp1UFl1cmNLN0ZiMU9UMVFBZ2g4d3BQc2hKYkNobFBwMS1fMVI0M3pnVFFyaXVqUkQ2TDdjczRhNk1HLVhxTjVILUpIVnlKTGhYUG54S2JiVmtXZjlEc1pGM0ZKTnplUEtGeDZjWVVVQUFnUTFjcmtEcWlTemp5R05LOGhOUGRSQk5XREFqZjBQX2l5WFFsUklvRmdPNVgzMlhaV05SRnNfeVJrbC03X0VBNXlMYndSUGhSRTE2Q2QwbGVlNHM3bU44TWdwRUhfWlhCRW90YmpkQ2ttR3Q1TmhRMmUzeUlYOTJJRmcweW54TUZjMHJqLXdaZlRSX2U3eEktb0VUbjlLQjRzdlFiMmNoZDdoc3BTRUZhZXZoY0xCYVBGRkYyeFNwMklwZzRTcWVuTmstaU5lakx1c29vcWR4UlBQYTFkWWJobnJRTmE0dFNzcHc3OWNxYVRsNzhudlZfVXl5SDJ3LXBBcjRXN245bGxHZWdidm1VNHI3Z3d1NjE4TGdIcjZaYnc4MWE2T01lVnBtRU5QckVYOFFpMVdPel9Bemx4dmRjRFd5N3JNTEtVLU91ZUZiMFRLRl82UlF2c2lDdjhDNmp1SlNSYzJHUjZKNU9OWDJ5UTFuWURlSGFkekE5YWhKNWRINlR2T0FxNHFtNElHb28zYnJfV2E5MmZSRE1iOTRHakZqbWdoamFWbGU2aC15R3pBZE55b1NDaENMU25adG93M1Q4M2ZIT3hWczVzRFhzS0h3TGprZXQ2dU5nNU9uSnhHenMzTWFSdXVJeTdkbnRjU2Rxd2JvS1RWUDhIaDJyRk1fVVpPUFlNTHNGeEZteEh3cTJ0NnA0QTlxLWlOUzlwNlp1cUFiU2ZSdE5qNWdQZzhIQmpOMG5BRndldw==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"registry.redhat.io":{"auth":"NTI4OTA4MjZ8dWhjLTFSanU3Mkp4WVRUNjdwZGFwRGlrckE2a0c5YjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtaREF4TnpFeU1HUm1OVEEwTURBM09EZGxPVFk0WldJNU16TTVaR1kyTnlKOS5SRlU0Mk56QkdYaGp1UFl1cmNLN0ZiMU9UMVFBZ2g4d3BQc2hKYkNobFBwMS1fMVI0M3pnVFFyaXVqUkQ2TDdjczRhNk1HLVhxTjVILUpIVnlKTGhYUG54S2JiVmtXZjlEc1pGM0ZKTnplUEtGeDZjWVVVQUFnUTFjcmtEcWlTemp5R05LOGhOUGRSQk5XREFqZjBQX2l5WFFsUklvRmdPNVgzMlhaV05SRnNfeVJrbC03X0VBNXlMYndSUGhSRTE2Q2QwbGVlNHM3bU44TWdwRUhfWlhCRW90YmpkQ2ttR3Q1TmhRMmUzeUlYOTJJRmcweW54TUZjMHJqLXdaZlRSX2U3eEktb0VUbjlLQjRzdlFiMmNoZDdoc3BTRUZhZXZoY0xCYVBGRkYyeFNwMklwZzRTcWVuTmstaU5lakx1c29vcWR4UlBQYTFkWWJobnJRTmE0dFNzcHc3OWNxYVRsNzhudlZfVXl5SDJ3LXBBcjRXN245bGxHZWdidm1VNHI3Z3d1NjE4TGdIcjZaYnc4MWE2T01lVnBtRU5QckVYOFFpMVdPel9Bemx4dmRjRFd5N3JNTEtVLU91ZUZiMFRLRl82UlF2c2lDdjhDNmp1SlNSYzJHUjZKNU9OWDJ5UTFuWURlSGFkekE5YWhKNWRINlR2T0FxNHFtNElHb28zYnJfV2E5MmZSRE1iOTRHakZqbWdoamFWbGU2aC15R3pBZE55b1NDaENMU25adG93M1Q4M2ZIT3hWczVzRFhzS0h3TGprZXQ2dU5nNU9uSnhHenMzTWFSdXVJeTdkbnRjU2Rxd2JvS1RWUDhIaDJyRk1fVVpPUFlNTHNGeEZteEh3cTJ0NnA0QTlxLWlOUzlwNlp1cUFiU2ZSdE5qNWdQZzhIQmpOMG5BRndldw==","email":"jonas.cavalcanti@goldentechnologia.com.br"}}}'
ENV isNodesWithDHCP="false"

#vSphere variables
ENV VCENTER_SERVER="vcenter.local"
ENV VCENTER_USER="admin@vmware.local"
ENV VCENTER_PASS="1q2w3e"
ENV VCENTER_DC="datacenter"
ENV VCENTER_DS="datastore"

# Add none root user
RUN useradd ocp${OCP_USERID}
RUN set -ex \
    && mkdir -p /etc/sudoers.d/ \
    && echo "ocp${OCP_USERID} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user \
    && mkdir -p ${OCP_SHARED_FOLDER}

#Enable supervisor process control
COPY pkgs/supervisor-4.1.0.tar.gz /tmp/pkgs/
COPY pkgs/supervisor-4.1.0-py2.py3-none-any.whl /tmp/pkgs/
RUN set -ex \
        && cd /tmp/pkgs \
        && pip3 install /tmp/pkgs/supervisor-4.1.0-py2.py3-none-any.whl
ADD confs/supervisord.conf /etc/supervisord.conf

#UnComment for OCP 3.11
ADD ansible/confs/ocp3/hosts /etc/ansible/hosts
ADD ansible/confs/ocp3/ansible.cfg ${OCP_USER_PATH}/.ansible.cfg

#Ansible Configurations 
ADD ansible/playbooks/ocp${OCP_VERSION} ${OCP_USER_PATH}/playbooks

RUN if [[ $OCP_VERSION == '4' ]]; then mv ${OCP_USER_PATH}/playbooks/install-config-$TIER.yaml ${OCP_USER_PATH}/playbooks/install-config.yaml; fi 

#Inicializations Scripts
ADD scripts/ocp${OCP_VERSION}/*.sh /
RUN chmod +x /*.sh && /usr/bin/chown ocp${OCP_USERID} /*.sh

RUN chown ocp${OCP_USERID} -R ${OCP_USER_PATH}/
RUN chown ocp${OCP_USERID} /var/www/html -R

RUN set -ex \
         && /usr/bin/chown ocp${OCP_USERID}:ocp${OCP_USERID} /run /var/log/httpd/\
         && sed -i "s/User apache/User ocp${OCP_USERID}/" /etc/httpd/conf/httpd.conf \
         && sed -i "s/Group apache/Group ocp${OCP_USERID}/" /etc/httpd/conf/httpd.conf

ADD scripts/init-httpd /init-httpd 
RUN chmod +x /init-httpd 

ADD scripts/start.sh /start.sh
RUN chmod +x /start.sh

VOLUME [ "${OCP_USER_PATH}" ]
USER ocp${OCP_USERID}

WORKDIR ${OCP_USER_PATH}

CMD ["/start.sh"]