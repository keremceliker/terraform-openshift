region               = "eu-west-1"
zone                 ="eu-west-1a"
bastion_instance_type = "t2.small"
instance_type         = "t2.large"
image                = "ami-4c457735"
key_name              = "anieto"

cluster_id = "openshift-tf"
master_count = 1
infra_count = 1
node_count = 1
osdisk_size = "30"

cidr_block = "172.16.0.0/16"
cidr_blocks = ["172.16.10.0/24","172.16.20.0/24","172.16.30.0/24","172.16.40.0/24"]
# cidr_blocks = ["172.31.10.0/24","172.16.20.0/24","172.16.30.0/24","172.16.40.0/24"]
default_sg_name = "default"
security_groups = ["bastion","master","infra","node"]

hosted_zone = "mithrandir.gq."
console_domain = "openshift-dev.mithrandir.gq"


elb_names = ["openshift-lb-master","openshift-lb-infra"]
