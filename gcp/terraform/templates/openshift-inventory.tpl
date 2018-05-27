[OSEv3:children]
masters
nodes
etcd


[masters]
${master_hosts}.c.first-project-200708.internal openshift_ip=${master_ips} openshift_schedulable=true

[etcd]
${master_hosts}.c.first-project-200708.internal openshift_ip=${master_ips}

[nodes]
${master_hosts}.c.first-project-200708.internal openshift_ip=${master_ips} openshift_schedulable=true openshift_node_labels="{'region': 'primary', 'zone': 'east'}"
${infra_hosts}.c.first-project-200708.internal openshift_ip=${infra_ips} openshift_schedulable=true openshift_node_labels="{'region': 'infra', 'zone': 'default'}"
${node_hosts}.c.first-project-200708.internal openshift_ip=${node_ips} openshift_schedulable=true openshift_node_labels="{'region': 'primary', 'zone': 'east'}"






[OSEv3:vars]
ansible_ssh_user=ale
ansible_become=true
ansible_ssh_private_key_file="/home/ale/.ssh/gcp"
enable_excluders=False
enable_docker_excluder=False
ansible_service_broker_install=False
openshift_web_console_install=True
containerized=True
os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'
openshift_disable_check=disk_availability,docker_storage,memory_availability,docker_image_availability



# Cloud Provider Configuration
openshift_cloudprovider_kind=gce
openshift_gcp_project=first-project-200708
openshift_gcp_prefix=at
openshift_gcp_multizone=False
openshift_master_dynamic_provisioning_enabled=True




openshift_node_kubelet_args={'pods-per-core': ['10']}

deployment_type=origin
openshift_deployment_type=origin


## Paquetes a instalar en control host: git ansible pyOpenSSL python-cryptography python-lxml python-passlib httpd-tools java-1.8.0-openjdk-headless

openshift_release=v3.9.0
openshift_pkg_version=v3.9.0
openshift_image_tag=v3.9.0
openshift_service_catalog_image_version=v3.9.0
template_service_broker_image_version=v3.9.0
template_service_broker_selector={"region":"infra"}
openshift_metrics_image_version=v3.9
openshift_logging_image_version=v3.9
#debug_level=4

osm_use_cockpit=true

openshift_metrics_install_metrics=True
openshift_logging_install_logging=True

#openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/home/ale/htpasswd'}]

openshift_public_hostname=openshift.mithrandir.gq
openshift_master_default_subdomain=apps.openshift.mithrandir.gq
openshift_master_api_port=8443
