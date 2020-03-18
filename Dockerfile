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
        bind-utils \
		supervisor

#OCP variables
ENV OCP_VERSION="4.3"
ENV OCP_BASEURL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest"
ENV OCP_CLUSTER_INSTALLER_NAME="installer"
ENV OCP_BOOTSTRAP_IGN_DNSNAME="bootstrap"
ENV OCP_WEBSERVER_IP="172.26.2.155"

ENV RHCOS_PACKAGES="https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${OCP_VERSION}/latest"

ENV OCP_USERID="3900"
ENV OCP_USER_PATH="/home/ocp${OCP_USERID}"

#Cluster variables
ENV BASE_DOMAIN="etice.corp"
ENV CLUSTER_NAME="ocp1"
ENV CLUSTER_CIDR="10.254.0.0/16"
ENV CLUSTER_SERVICE_NETWORK="172.30.0.0/16"
ENV TIER="vsphere"

#OCP variables
ENV WORKERS_REPLICS="4"
ENV WORKERS_DNS_NAMES="worker-0 worker-1 worker-2 worker-3"
ENV MASTER_REPLICS="3"
ENV MASTERS_DNS_NAMES="master-0 master-1 master-2"
ENV ETCD_DNS_NAMES="etcd-0 etcd-1 etcd-2"
ENV PULL_SECRET='{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2pvbmFzY2F2YWxjYW50aWdvbGRlbnRlY2hub2xvZ2lhY29tYnIxcmp1NzJqeHl0dDY3cGRhcGRpa3JhNmtnOWI6NjlTQ0NGQklWQTY2Tk1BTjBEVUdaTjIxUU5OSERKQVgzSU5ER0dDQlpPV1hINDlGNEg2MTJHRExUWDlONjJRMQ==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2pvbmFzY2F2YWxjYW50aWdvbGRlbnRlY2hub2xvZ2lhY29tYnIxcmp1NzJqeHl0dDY3cGRhcGRpa3JhNmtnOWI6NjlTQ0NGQklWQTY2Tk1BTjBEVUdaTjIxUU5OSERKQVgzSU5ER0dDQlpPV1hINDlGNEg2MTJHRExUWDlONjJRMQ==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"registry.connect.redhat.com":{"auth":"NTI4OTA4MjZ8dWhjLTFSanU3Mkp4WVRUNjdwZGFwRGlrckE2a0c5YjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtaREF4TnpFeU1HUm1OVEEwTURBM09EZGxPVFk0WldJNU16TTVaR1kyTnlKOS5SRlU0Mk56QkdYaGp1UFl1cmNLN0ZiMU9UMVFBZ2g4d3BQc2hKYkNobFBwMS1fMVI0M3pnVFFyaXVqUkQ2TDdjczRhNk1HLVhxTjVILUpIVnlKTGhYUG54S2JiVmtXZjlEc1pGM0ZKTnplUEtGeDZjWVVVQUFnUTFjcmtEcWlTemp5R05LOGhOUGRSQk5XREFqZjBQX2l5WFFsUklvRmdPNVgzMlhaV05SRnNfeVJrbC03X0VBNXlMYndSUGhSRTE2Q2QwbGVlNHM3bU44TWdwRUhfWlhCRW90YmpkQ2ttR3Q1TmhRMmUzeUlYOTJJRmcweW54TUZjMHJqLXdaZlRSX2U3eEktb0VUbjlLQjRzdlFiMmNoZDdoc3BTRUZhZXZoY0xCYVBGRkYyeFNwMklwZzRTcWVuTmstaU5lakx1c29vcWR4UlBQYTFkWWJobnJRTmE0dFNzcHc3OWNxYVRsNzhudlZfVXl5SDJ3LXBBcjRXN245bGxHZWdidm1VNHI3Z3d1NjE4TGdIcjZaYnc4MWE2T01lVnBtRU5QckVYOFFpMVdPel9Bemx4dmRjRFd5N3JNTEtVLU91ZUZiMFRLRl82UlF2c2lDdjhDNmp1SlNSYzJHUjZKNU9OWDJ5UTFuWURlSGFkekE5YWhKNWRINlR2T0FxNHFtNElHb28zYnJfV2E5MmZSRE1iOTRHakZqbWdoamFWbGU2aC15R3pBZE55b1NDaENMU25adG93M1Q4M2ZIT3hWczVzRFhzS0h3TGprZXQ2dU5nNU9uSnhHenMzTWFSdXVJeTdkbnRjU2Rxd2JvS1RWUDhIaDJyRk1fVVpPUFlNTHNGeEZteEh3cTJ0NnA0QTlxLWlOUzlwNlp1cUFiU2ZSdE5qNWdQZzhIQmpOMG5BRndldw==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"registry.redhat.io":{"auth":"NTI4OTA4MjZ8dWhjLTFSanU3Mkp4WVRUNjdwZGFwRGlrckE2a0c5YjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtaREF4TnpFeU1HUm1OVEEwTURBM09EZGxPVFk0WldJNU16TTVaR1kyTnlKOS5SRlU0Mk56QkdYaGp1UFl1cmNLN0ZiMU9UMVFBZ2g4d3BQc2hKYkNobFBwMS1fMVI0M3pnVFFyaXVqUkQ2TDdjczRhNk1HLVhxTjVILUpIVnlKTGhYUG54S2JiVmtXZjlEc1pGM0ZKTnplUEtGeDZjWVVVQUFnUTFjcmtEcWlTemp5R05LOGhOUGRSQk5XREFqZjBQX2l5WFFsUklvRmdPNVgzMlhaV05SRnNfeVJrbC03X0VBNXlMYndSUGhSRTE2Q2QwbGVlNHM3bU44TWdwRUhfWlhCRW90YmpkQ2ttR3Q1TmhRMmUzeUlYOTJJRmcweW54TUZjMHJqLXdaZlRSX2U3eEktb0VUbjlLQjRzdlFiMmNoZDdoc3BTRUZhZXZoY0xCYVBGRkYyeFNwMklwZzRTcWVuTmstaU5lakx1c29vcWR4UlBQYTFkWWJobnJRTmE0dFNzcHc3OWNxYVRsNzhudlZfVXl5SDJ3LXBBcjRXN245bGxHZWdidm1VNHI3Z3d1NjE4TGdIcjZaYnc4MWE2T01lVnBtRU5QckVYOFFpMVdPel9Bemx4dmRjRFd5N3JNTEtVLU91ZUZiMFRLRl82UlF2c2lDdjhDNmp1SlNSYzJHUjZKNU9OWDJ5UTFuWURlSGFkekE5YWhKNWRINlR2T0FxNHFtNElHb28zYnJfV2E5MmZSRE1iOTRHakZqbWdoamFWbGU2aC15R3pBZE55b1NDaENMU25adG93M1Q4M2ZIT3hWczVzRFhzS0h3TGprZXQ2dU5nNU9uSnhHenMzTWFSdXVJeTdkbnRjU2Rxd2JvS1RWUDhIaDJyRk1fVVpPUFlNTHNGeEZteEh3cTJ0NnA0QTlxLWlOUzlwNlp1cUFiU2ZSdE5qNWdQZzhIQmpOMG5BRndldw==","email":"jonas.cavalcanti@goldentechnologia.com.br"}}}'
ENV OCP_SSH_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDi3aUYgo1Q25tPxqwlsI4MTTS4iL0oVOtUPuwy8vB6R5sJvuEqq6/dryE03Ph8hjWm70/pRqKdpSHz2xDIG+RFTEBMPWIAEWAbrBjF0n2BsU1do/AW2Z/Xv7JtD0wtlp4ybWa6dwiGVKwQ81j0RxFJ5aLiC/kABZxPUlrWOGrAL0swUna3AaOjfC0azmNjgvNPmX6HGY3KTP3h4vudjDnN37dI/Mx0iNh90LMptShxgwQ06fweNkxQJh0b0gwDLuQww/Sr47D+LzejdY8y7z58cEA5zksifThyWw2PA5VXOZaiRkcvjOkLTIhp0ELPqgD5hRLUQ2y7H5ZFZFl2kFdTCP0hcGIqiv/u2vSy+a/DiLAGG+yDUN1q3GkTZ+GycH8MqnWvsli9EDrbu0joyoQCArx+kj1hj0HtNCm+bsnT09Vrw8jNiXc9fwQHPVN7dWzVBNWnoUZCVtcMvwn2jyosIgCWPAj+YSGBmqpZqm7zjQmP1v2mtA/9f/+ElsD91qeYFnDvwpNjhzPfEovamwzYcJCMsA+36ITNc79cOSk39GJ/JP2hVqxrZYm+ZCs5VkPpqdE6IRbNef9AGzq3Vgs/UJaz8HZH4pAEJ3ihAxhlfXc7jj+JiZyizWmV2aA6BXTKb7OpZ2s6LC+UC+4+BTGp7IFBLk8ZHk7BxCzU5rvqGQ== ocp3900@ocp4.3-bootstrap'
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

ADD confs/install-config.yaml ${OCP_USER_PATH}/install-config.yaml

ADD confs/ssh/id_rsa ${OCP_USER_PATH}/.ssh/id_rsa
ADD confs/ssh/id_rsa.pub ${OCP_USER_PATH}/.ssh/id_rsa.pub

RUN set -x \
        && chmod 700  ${OCP_USER_PATH}/.ssh \
        && chmod 600  ${OCP_USER_PATH}/.ssh/id_rsa \
        && chmod 644  ${OCP_USER_PATH}/.ssh/id_rsa.pub

RUN chown ocp${OCP_USERID} -R ${OCP_USER_PATH}/*
RUN chown ocp${OCP_USERID} /var/www/html -R

ADD confs/init-ocp-configd /init-ocp-configd
RUN chmod +x /init-ocp-configd && /usr/bin/chown ocp${OCP_USERID} /init-ocp-configd

ADD confs/monitor-bootstrap-complete.sh /monitor-bootstrap-complete.sh
RUN chmod +x /monitor-bootstrap-complete.sh && /usr/bin/chown ocp${OCP_USERID} /monitor-bootstrap-complete.sh

ADD confs/monitor-install-completion.sh /monitor-install-completion.sh
RUN chmod +x /monitor-install-completion.sh && /usr/bin/chown ocp${OCP_USERID} /monitor-install-completion.sh

ADD confs/init-httpd /init-httpd 
RUN chmod +x /init-httpd 

#&& /usr/bin/chown ocp${OCP_USERID} /init-httpd
RUN set -ex \
         && /usr/bin/chown ocp${OCP_USERID}:ocp${OCP_USERID} /run /var/log/httpd/\
         && sed -i "s/User apache/User ocp${OCP_USERID}/" /etc/httpd/conf/httpd.conf \
         && sed -i "s/Group apache/Group ocp${OCP_USERID}/" /etc/httpd/conf/httpd.conf

ADD confs/start.sh /start.sh
RUN chmod +x /start.sh

VOLUME [ "${OCP_USER_PATH}" ]
USER ocp${OCP_USERID}

WORKDIR ${OCP_USER_PATH}

CMD ["/start.sh"]