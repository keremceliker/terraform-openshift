data "aws_security_group" "default" {
  name = "${var.default_sg_name}"
}



# resource "aws_security_group" "sg_tf_bastion" {
#   name        = "Security Group Terraform Bastion"
#   description = "Security Group Terraform Bastion"
# }

resource "aws_security_group" "sg_tf" {
  count          = "${length(var.security_groups)}"
  name           = "${var.security_groups[count.index]}-${terraform.workspace}"
  description    = "${var.security_groups[count.index]}"
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
