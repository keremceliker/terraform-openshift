[OSEv3:children]
masters
nodes
etcd


[masters]
${master_hosts} openshift_ip=${master_ips} openshift_schedulable=true

[etcd]
${master_hosts} openshift_ip=${master_ips}

[nodes]
${master_hosts} openshift_ip=${master_ips} openshift_schedulable=true openshift_node_labels="{'region': 'primary', 'zone': 'east'}"
${infra_hosts} openshift_ip=${infra_ips} openshift_schedulable=true openshift_node_labels="{'region': 'infra', 'zone': 'default'}"
${node_hosts}



[OSEv3:vars]
ansible_ssh_user=centos
ansible_become=true
ansible_ssh_private_key_file="/home/centos/.ssh/aws"
enable_excluders=False
enable_docker_excluder=False
ansible_service_broker_install=False
openshift_web_console_install=True
containerized=True
os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'
openshift_disable_check=disk_availability,docker_storage,memory_availability,docker_image_availability



# Cloud Provider Configuration
#
# Note: You may make use of environment variables rather than store
# sensitive configuration within the ansible inventory.
# For example:
#openshift_cloudprovider_aws_access_key="{{ lookup('env','AWS_ACCESS_KEY_ID') }}"
#openshift_cloudprovider_aws_secret_key="{{ lookup('env','AWS_SECRET_ACCESS_KEY') }}"
#
#openshift_clusterid=unique_identifier_per_availablility_zone
openshift_clusterid=${cluster_id}
#
# AWS (Using API Credentials)
#openshift_cloudprovider_kind=aws
#openshift_cloudprovider_aws_access_key=aws_access_key_id
#openshift_cloudprovider_aws_secret_key=aws_secret_access_key
#
# AWS (Using IAM Profiles)
#openshift_cloudprovider_kind=aws
# Note: IAM roles must exist before launching the instances.



openshift_node_kubelet_args={'pods-per-core': ['10']}

deployment_type=origin
openshift_deployment_type=origin


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
