FROM centos:8

RUN yum update -y && yum install -y \
		epel-release

RUN yum update -y && yum install -y \
        vim \
        curl \
        openssh \
        wget \
        httpd \
        sudo \
		supervisor

#OCP variables
ENV OCP_VERSION="4.3"
ENV OCP_BASEURL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest"
ENV OCP_BOOTSTRAP_IGN_DNSNAME="bastion.mycompany.com"

ENV RHCOS_PACKAGES="https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${OCP_VERSION}/latest"

ENV OCP_USERID=3900 
ENV OCP_USER_PATH="/home/ocp${OCP_USERID}"

#Cluster variables
ENV BASE_DOMAIN="mycompany.com"
ENV WORKERS_REPLICS="4"
ENV MASTER_REPLICS="3"
ENV CLUSTER_NAME="cluster1"
ENV CLUSTER_CIDR="10.254.0.0/16"
ENV CLUSTER_SERVICE_NETWORK="172.30.0.0/16"
ENV TIER="vsphere"
ENV PULL_SECRET='{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2pvbmFzY2F2YWxjYW50aWdvbGRlbnRlY2hub2xvZ2lhY29tYnIxcmp1NzJqeHl0dDY3cGRhcGRpa3JhNmtnOWI6NjlTQ0NGQklWQTY2Tk1BTjBEVUdaTjIxUU5OSERKQVgzSU5ER0dDQlpPV1hINDlGNEg2MTJHRExUWDlONjJRMQ==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2pvbmFzY2F2YWxjYW50aWdvbGRlbnRlY2hub2xvZ2lhY29tYnIxcmp1NzJqeHl0dDY3cGRhcGRpa3JhNmtnOWI6NjlTQ0NGQklWQTY2Tk1BTjBEVUdaTjIxUU5OSERKQVgzSU5ER0dDQlpPV1hINDlGNEg2MTJHRExUWDlONjJRMQ==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"registry.connect.redhat.com":{"auth":"NTI4OTA4MjZ8dWhjLTFSanU3Mkp4WVRUNjdwZGFwRGlrckE2a0c5YjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtaREF4TnpFeU1HUm1OVEEwTURBM09EZGxPVFk0WldJNU16TTVaR1kyTnlKOS5SRlU0Mk56QkdYaGp1UFl1cmNLN0ZiMU9UMVFBZ2g4d3BQc2hKYkNobFBwMS1fMVI0M3pnVFFyaXVqUkQ2TDdjczRhNk1HLVhxTjVILUpIVnlKTGhYUG54S2JiVmtXZjlEc1pGM0ZKTnplUEtGeDZjWVVVQUFnUTFjcmtEcWlTemp5R05LOGhOUGRSQk5XREFqZjBQX2l5WFFsUklvRmdPNVgzMlhaV05SRnNfeVJrbC03X0VBNXlMYndSUGhSRTE2Q2QwbGVlNHM3bU44TWdwRUhfWlhCRW90YmpkQ2ttR3Q1TmhRMmUzeUlYOTJJRmcweW54TUZjMHJqLXdaZlRSX2U3eEktb0VUbjlLQjRzdlFiMmNoZDdoc3BTRUZhZXZoY0xCYVBGRkYyeFNwMklwZzRTcWVuTmstaU5lakx1c29vcWR4UlBQYTFkWWJobnJRTmE0dFNzcHc3OWNxYVRsNzhudlZfVXl5SDJ3LXBBcjRXN245bGxHZWdidm1VNHI3Z3d1NjE4TGdIcjZaYnc4MWE2T01lVnBtRU5QckVYOFFpMVdPel9Bemx4dmRjRFd5N3JNTEtVLU91ZUZiMFRLRl82UlF2c2lDdjhDNmp1SlNSYzJHUjZKNU9OWDJ5UTFuWURlSGFkekE5YWhKNWRINlR2T0FxNHFtNElHb28zYnJfV2E5MmZSRE1iOTRHakZqbWdoamFWbGU2aC15R3pBZE55b1NDaENMU25adG93M1Q4M2ZIT3hWczVzRFhzS0h3TGprZXQ2dU5nNU9uSnhHenMzTWFSdXVJeTdkbnRjU2Rxd2JvS1RWUDhIaDJyRk1fVVpPUFlNTHNGeEZteEh3cTJ0NnA0QTlxLWlOUzlwNlp1cUFiU2ZSdE5qNWdQZzhIQmpOMG5BRndldw==","email":"jonas.cavalcanti@goldentechnologia.com.br"},"registry.redhat.io":{"auth":"NTI4OTA4MjZ8dWhjLTFSanU3Mkp4WVRUNjdwZGFwRGlrckE2a0c5YjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmtaREF4TnpFeU1HUm1OVEEwTURBM09EZGxPVFk0WldJNU16TTVaR1kyTnlKOS5SRlU0Mk56QkdYaGp1UFl1cmNLN0ZiMU9UMVFBZ2g4d3BQc2hKYkNobFBwMS1fMVI0M3pnVFFyaXVqUkQ2TDdjczRhNk1HLVhxTjVILUpIVnlKTGhYUG54S2JiVmtXZjlEc1pGM0ZKTnplUEtGeDZjWVVVQUFnUTFjcmtEcWlTemp5R05LOGhOUGRSQk5XREFqZjBQX2l5WFFsUklvRmdPNVgzMlhaV05SRnNfeVJrbC03X0VBNXlMYndSUGhSRTE2Q2QwbGVlNHM3bU44TWdwRUhfWlhCRW90YmpkQ2ttR3Q1TmhRMmUzeUlYOTJJRmcweW54TUZjMHJqLXdaZlRSX2U3eEktb0VUbjlLQjRzdlFiMmNoZDdoc3BTRUZhZXZoY0xCYVBGRkYyeFNwMklwZzRTcWVuTmstaU5lakx1c29vcWR4UlBQYTFkWWJobnJRTmE0dFNzcHc3OWNxYVRsNzhudlZfVXl5SDJ3LXBBcjRXN245bGxHZWdidm1VNHI3Z3d1NjE4TGdIcjZaYnc4MWE2T01lVnBtRU5QckVYOFFpMVdPel9Bemx4dmRjRFd5N3JNTEtVLU91ZUZiMFRLRl82UlF2c2lDdjhDNmp1SlNSYzJHUjZKNU9OWDJ5UTFuWURlSGFkekE5YWhKNWRINlR2T0FxNHFtNElHb28zYnJfV2E5MmZSRE1iOTRHakZqbWdoamFWbGU2aC15R3pBZE55b1NDaENMU25adG93M1Q4M2ZIT3hWczVzRFhzS0h3TGprZXQ2dU5nNU9uSnhHenMzTWFSdXVJeTdkbnRjU2Rxd2JvS1RWUDhIaDJyRk1fVVpPUFlNTHNGeEZteEh3cTJ0NnA0QTlxLWlOUzlwNlp1cUFiU2ZSdE5qNWdQZzhIQmpOMG5BRndldw==","email":"jonas.cavalcanti@goldentechnologia.com.br"}}}'
ENV OCP_SSH_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwYJ7n17NSKgF4stmxnRUVOVF2oqlucSb192Cz1vwbdRcnQMIyKGv8oJTnM6B9THi4OzAEHS5/JTUe0yhnlIoPe47Dz1n6XL4zMExF93C8NwIhnP2VDjp8W4cU+ArEi7GD4hUSUt20eSjPscPJ/mI+MN1mDnPM94XzVcfb/icBhBq43vM/lLywEsUgvG1zkg3ZEVQT13eZ0iHG3L3kvuDtGSAuB0FOAXu0vdzZS4tDtT/fQ7oMNPXIpBRWdJ3iZjw2ZAQ+mr6LV9ioTvCLAeezOCWwELH9N5LBsu5mbw9O0etgfbGOR9JL2Kiy+ss4xJ8jMABSppDli8eofer1RK4gnESqvaqFzkDnGlqHN6j2HwJI21KWcWKyieQ/xPTSufmWfgsvpIxbHvbj+FJaILoUKPNuc3IoL3PS8gbejgEz+5ybKdFu/YsY8QyIHe55+zUvZhiue+Y9sgKfS/0l4FjHHg+X2sBUsQR4hR+ntmq+HnW6Y8kPwywrTTfy5YdIIUoig7U4rnzqKYbq3gvgLWdzkyOQV02Uk+ZJOuKsuNFtEHCMsATVMPzZY1tNST0C5htShvB1VzOjGUROJfCik16nQPLZXZ8RXVnHGFnxyKUmgJXBRcLRPyPVJiKkz8tEQ137KXC4NJpxAzoRlL6W8IwPjw4H2a8MTZZTM9vFjDsRrQ== initiator@ocp-bootstrap-ignition'

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

RUN chown ocp${OCP_USERID} -R ${OCP_USER_PATH}/*
RUN chown ocp${OCP_USERID} /var/www/html -R

ADD confs/init-ocp-configd /init-ocp-configd
RUN chmod +x /init-ocp-configd && /usr/bin/chown ocp${OCP_USERID} /init-ocp-configd

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