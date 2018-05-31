
zone                 ="eu-west-1"
bastion_instance_type = "t2.small"
instance_type         = "t2.large"
image                = "ami-4c457735"
key_name              = "anieto"

cluster_id = "openshift-aws"
master_count = 1
infra_count = 1
node_count = 1
osdisk_size = "30"

cidr_blocks = ["172.16.10.0/24","172.16.20.0/24","172.16.30.0/24","172.16.40.0/24"]
default_sg_name = "default"
security_groups = ["bastion","master","infra","node"]
