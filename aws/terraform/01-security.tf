resource "aws_vpc" "openshift" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.cluster_id}-${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "openshift" {
  vpc_id = "${aws_vpc.openshift.id}"

  tags {
    Name = "${var.cluster_id}-${terraform.workspace}"
  }
}


resource "aws_default_route_table" "openshift" {
  default_route_table_id = "${aws_vpc.openshift.main_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.openshift.id}"
  }

  tags {
    Name = "${var.cluster_id}-${terraform.workspace}"
  }
}



resource "aws_subnet" "openshift" {
  count                = "${length(var.cidr_blocks)}"
  vpc_id               = "${aws_vpc.openshift.id}"
  cidr_block           = "${var.cidr_blocks[count.index]}"
  availability_zone    = "${var.zone}"
  tags {
    Name = "${var.cluster_id}-${var.security_groups[count.index]}-${terraform.workspace}"
  }
}




data "aws_security_group" "default" {
  name = "${var.default_sg_name}"
  vpc_id = "${aws_vpc.openshift.id}"
}



# resource "aws_security_group" "sg_tf_bastion" {
#   name        = "Security Group Terraform Bastion"
#   description = "Security Group Terraform Bastion"
# }

resource "aws_security_group" "sg_tf" {
  count          = "${length(var.security_groups)}"
  name           = "${var.security_groups[count.index]}-${terraform.workspace}"
  description    = "${var.security_groups[count.index]}"
  vpc_id         = "${aws_vpc.openshift.id}"
}



resource "aws_security_group_rule" "bastion_ssh_tf" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]

  # security_group_id = "${aws_security_group.sg_tf_bastion.id}"
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 0)}"
}


resource "aws_security_group_rule" "master_8443_tf" {
  type            = "ingress"
  from_port       = 8443
  to_port         = 8443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]

  # security_group_id = "${aws_security_group.sg_tf_bastion.id}"
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 1)}"
}


resource "aws_security_group_rule" "infra_8443_tf" {
  type            = "ingress"
  from_port       = 8443
  to_port         = 8443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]

  # security_group_id = "${aws_security_group.sg_tf_bastion.id}"
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 2)}"
}


resource "aws_security_group_rule" "infra_443_tf" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]

  # security_group_id = "${aws_security_group.sg_tf_bastion.id}"
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 2)}"
}


resource "aws_security_group_rule" "infra_80_tf" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  # prefix_list_ids = ["pl-12c4e678"]

  # security_group_id = "${aws_security_group.sg_tf_bastion.id}"
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 2)}"
}
