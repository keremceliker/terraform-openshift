data "aws_security_group" "default" {
  name = "${var.default_sg_name}"
  vpc_id = "${aws_vpc.openshift.id}"
}


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
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 0)}"
}


resource "aws_security_group_rule" "master_8443_tf" {
  type            = "ingress"
  from_port       = 8443
  to_port         = 8443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 1)}"
}


resource "aws_security_group_rule" "infra_8443_tf" {
  type            = "ingress"
  from_port       = 8443
  to_port         = 8443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 2)}"
}


resource "aws_security_group_rule" "infra_443_tf" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 2)}"
}


resource "aws_security_group_rule" "infra_80_tf" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${element(aws_security_group.sg_tf.*.id, 2)}"
}
