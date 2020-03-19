FROM centos:7.7.1908

RUN yum update -y && yum install -y \
		epel-release

RUN yum update -y && yum install -y \
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
                            bind-utils \
                            ansible \
                            supervisor

#OCP variables
ENV OCP_VERSION="3.11"
ENV OCP_BASEURL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest"
ENV OCP_CLUSTER_INSTALLER_NAME="installer"
ENV OCP_BOOTSTRAP_IGN_DNSNAME="bootstrap"
ENV OCP_WEBSERVER_IP="172.26.2.155"

ENV RHCOS_PACKAGES="https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${OCP_VERSION}/latest"

ENV OCP_USERID="3900"
ENV OCP_USER_PATH="/home/ocp${OCP_USERID}"

#Cluster variables
ENV BASE_DOMAIN="jdhlab.corp"
ENV CLUSTER_NAME="ocp1"
ENV CLUSTER_CIDR="10.254.0.0/16"
ENV CLUSTER_SERVICE_NETWORK="172.30.0.0/16"
ENV TIER="vsphere"

#OCP variables
ENV WORKERS_REPLICS="4"
ENV WORKERS_DNS_NAMES="worker1 worker2 worker3 worker4"
ENV MASTER_REPLICS="1"
ENV MASTERS_DNS_NAMES="master1"
ENV ETCD_DNS_NAMES="etcd-0"
ENV PULL_SECRET='{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2pvbmFzY2F2YWxjYW50aWdvbGRlbnRlY2hub2xvZ2lhY29tYnIxcmp1NzJqeHl0dDY3cGRhcGRpa3JhNmtnOWI6NjlTQ0NGQklWQTY2Tk1BTjBEVUdaTjIxUU5OSERKQVgzSU5ER0dDQlpPV1hINDlGNEg2MTJHRExUWDlONjJRMQ==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2pvbmFzY2F2YWxjYW50aWdvbGRlbnRlY2hub2xvZ2lhY29tYnIxcmp1NzJqeHl0dDY3cGRhcGRpa3JhNmtnOWI6NjlTQ0NGQklWQTY2Tk1BTjBEVUdaTjIxUU5OSERKQVgzSU5ER0dDQlpPV1hINDlGNEg2MTJHRExUWDlONjJRMQ==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"registry.connect.redhat.com":{"auth":"NTI4OTA4MjZ8dWhjLTFSanU3Mkp4WVRUNjdwZGFwRGlrckE2a0c5YjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtaREF4TnpFeU1HUm1OVEEwTURBM09EZGxPVFk0WldJNU16TTVaR1kyTnlKOS5SRlU0Mk56QkdYaGp1UFl1cmNLN0ZiMU9UMVFBZ2g4d3BQc2hKYkNobFBwMS1fMVI0M3pnVFFyaXVqUkQ2TDdjczRhNk1HLVhxTjVILUpIVnlKTGhYUG54S2JiVmtXZjlEc1pGM0ZKTnplUEtGeDZjWVVVQUFnUTFjcmtEcWlTemp5R05LOGhOUGRSQk5XREFqZjBQX2l5WFFsUklvRmdPNVgzMlhaV05SRnNfeVJrbC03X0VBNXlMYndSUGhSRTE2Q2QwbGVlNHM3bU44TWdwRUhfWlhCRW90YmpkQ2ttR3Q1TmhRMmUzeUlYOTJJRmcweW54TUZjMHJqLXdaZlRSX2U3eEktb0VUbjlLQjRzdlFiMmNoZDdoc3BTRUZhZXZoY0xCYVBGRkYyeFNwMklwZzRTcWVuTmstaU5lakx1c29vcWR4UlBQYTFkWWJobnJRTmE0dFNzcHc3OWNxYVRsNzhudlZfVXl5SDJ3LXBBcjRXN245bGxHZWdidm1VNHI3Z3d1NjE4TGdIcjZaYnc4MWE2T01lVnBtRU5QckVYOFFpMVdPel9Bemx4dmRjRFd5N3JNTEtVLU91ZUZiMFRLRl82UlF2c2lDdjhDNmp1SlNSYzJHUjZKNU9OWDJ5UTFuWURlSGFkekE5YWhKNWRINlR2T0FxNHFtNElHb28zYnJfV2E5MmZSRE1iOTRHakZqbWdoamFWbGU2aC15R3pBZE55b1NDaENMU25adG93M1Q4M2ZIT3hWczVzRFhzS0h3TGprZXQ2dU5nNU9uSnhHenMzTWFSdXVJeTdkbnRjU2Rxd2JvS1RWUDhIaDJyRk1fVVpPUFlNTHNGeEZteEh3cTJ0NnA0QTlxLWlOUzlwNlp1cUFiU2ZSdE5qNWdQZzhIQmpOMG5BRndldw==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"registry.redhat.io":{"auth":"NTI4OTA4MjZ8dWhjLTFSanU3Mkp4WVRUNjdwZGFwRGlrckE2a0c5YjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtaREF4TnpFeU1HUm1OVEEwTURBM09EZGxPVFk0WldJNU16TTVaR1kyTnlKOS5SRlU0Mk56QkdYaGp1UFl1cmNLN0ZiMU9UMVFBZ2g4d3BQc2hKYkNobFBwMS1fMVI0M3pnVFFyaXVqUkQ2TDdjczRhNk1HLVhxTjVILUpIVnlKTGhYUG54S2JiVmtXZjlEc1pGM0ZKTnplUEtGeDZjWVVVQUFnUTFjcmtEcWlTemp5R05LOGhOUGRSQk5XREFqZjBQX2l5WFFsUklvRmdPNVgzMlhaV05SRnNfeVJrbC03X0VBNXlMYndSUGhSRTE2Q2QwbGVlNHM3bU44TWdwRUhfWlhCRW90YmpkQ2ttR3Q1TmhRMmUzeUlYOTJJRmcweW54TUZjMHJqLXdaZlRSX2U3eEktb0VUbjlLQjRzdlFiMmNoZDdoc3BTRUZhZXZoY0xCYVBGRkYyeFNwMklwZzRTcWVuTmstaU5lakx1c29vcWR4UlBQYTFkWWJobnJRTmE0dFNzcHc3OWNxYVRsNzhudlZfVXl5SDJ3LXBBcjRXN245bGxHZWdidm1VNHI3Z3d1NjE4TGdIcjZaYnc4MWE2T01lVnBtRU5QckVYOFFpMVdPel9Bemx4dmRjRFd5N3JNTEtVLU91ZUZiMFRLRl82UlF2c2lDdjhDNmp1SlNSYzJHUjZKNU9OWDJ5UTFuWURlSGFkekE5YWhKNWRINlR2T0FxNHFtNElHb28zYnJfV2E5MmZSRE1iOTRHakZqbWdoamFWbGU2aC15R3pBZE55b1NDaENMU25adG93M1Q4M2ZIT3hWczVzRFhzS0h3TGprZXQ2dU5nNU9uSnhHenMzTWFSdXVJeTdkbnRjU2Rxd2JvS1RWUDhIaDJyRk1fVVpPUFlNTHNGeEZteEh3cTJ0NnA0QTlxLWlOUzlwNlp1cUFiU2ZSdE5qNWdQZzhIQmpOMG5BRndldw==","email":"jonas.cavalcanti@goldentechnologia.com.br"}}}'
ENV OCP_SSH_KEY='sshkey'
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
    && echo "ocp${OCP_USERID} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user

ADD confs/supervisord.conf /etc/supervisord.conf

#ADD confs/install-config.yaml ${OCP_USER_PATH}/install-config.yaml

#Ansible Configurations
ADD ansible/confs/hosts /etc/ansible/hosts
ADD ansible/confs/ansible.cfg ${OCP_USER_PATH}/.ansible.cfg
ADD ansible/playbooks/1-subscribe-nodes.yaml ${OCP_USER_PATH}/playbooks/1-subscribe-nodes.yaml
ADD ansible/playbooks/2-prepare-nodes.yaml ${OCP_USER_PATH}/playbooks/2-prepare-nodes.yaml

RUN chown ocp${OCP_USERID} -R ${OCP_USER_PATH}/*
RUN chown ocp${OCP_USERID} /var/www/html -R

ADD scripts/init-ocp-configd /init-ocp-configd
RUN chmod +x /init-ocp-configd && /usr/bin/chown ocp${OCP_USERID} /init-ocp-configd

ADD scripts/monitor-bootstrap-complete.sh /monitor-bootstrap-complete.sh
RUN chmod +x /monitor-bootstrap-complete.sh && /usr/bin/chown ocp${OCP_USERID} /monitor-bootstrap-complete.sh

ADD scripts/monitor-install-completion.sh /monitor-install-completion.sh
RUN chmod +x /monitor-install-completion.sh && /usr/bin/chown ocp${OCP_USERID} /monitor-install-completion.sh

ADD scripts/init-httpd /init-httpd 
RUN chmod +x /init-httpd 

#&& /usr/bin/chown ocp${OCP_USERID} /init-httpd
RUN set -ex \
         && /usr/bin/chown ocp${OCP_USERID}:ocp${OCP_USERID} /run /var/log/httpd/\
         && sed -i "s/User apache/User ocp${OCP_USERID}/" /etc/httpd/conf/httpd.conf \
         && sed -i "s/Group apache/Group ocp${OCP_USERID}/" /etc/httpd/conf/httpd.conf

ADD scripts/start.sh /start.sh
RUN chmod +x /start.sh

VOLUME [ "${OCP_USER_PATH}" ]
USER ocp${OCP_USERID}

WORKDIR ${OCP_USER_PATH}

CMD ["/start.sh"]