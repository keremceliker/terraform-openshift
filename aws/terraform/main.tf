### EXAMPLE
# resource "aws_instance" "master" {
#   ami           = "${var.image}"
#   instance_type = "${var.instance_type}"
#   availability_zone = "${var.zone}a"
#   # iam_instance_profile = "iam:PassRole"
#   tags {
#     Name = "master-terraform-${terraform.workspace}"
#     # kubernetes.io/cluster/openshift = "openshift-aws-terraform"
#     # kubernetes.io/cluster/<name>,Value=${var.cluster_id}
#   }
# }

# resource "aws_vpc" "openshift" {
#   cidr_block = "172.16.0.0/16"
#   enable_dns_hostnames = true
#   tags {
#     Name = "tf-openshift"
#   }
# }
#
# resource "aws_subnet" "openshift" {
#   count                = "${length(var.cidr_blocks)}"
#   vpc_id               = "${aws_vpc.openshift.id}"
#   cidr_block           = "${var.cidr_blocks[count.index]}"
#   availability_zone    = "${var.zone}a"
#   tags {
#     Name   = "tf-openshift"
#   }
# }
#
#


resource "aws_instance" "bastion" {
  ami               = "${var.image}"
  instance_type     = "${var.bastion_instance_type}"
  availability_zone = "${var.zone}a"
  key_name          = "${var.key_name}"
  # subnet_id         = "${element(aws_subnet.openshift.*.id, 0)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 0)}"]
  # "${data.aws_security_group.selected.vpc_id}"
  # vpc_security_group_ids = ["sg-7f78e202"]
  tags {
    Name = "bastion-tf-${terraform.workspace}"
  }

  # provisioner "file" {
  #   connection {
  #     user = "centos"
  #  }
  #
  #   source = "scripts/bastion.sh"
  #   destination = "/home/centos/bastion.sh"
  # }

  provisioner "remote-exec" {

    connection {
      user = "centos"
      private_key = "${file("certs/anieto.pem")}"
    }

    inline = [
      "sudo yum install -y epel-release",
      "sudo yum install -y git ansible pyOpenSSL python-cryptography python-lxml python-passlib httpd-tools java-1.8.0-openjdk-headless",
      "git clone -b release-3.9 https://github.com/openshift/openshift-ansible.git",
    ]
  }
}


resource "aws_instance" "master" {
  ami           = "${var.image}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.zone}a"
  key_name          = "${var.key_name}"
  # subnet_id         = "${element(aws_subnet.openshift.*.id, 1)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 1)}"]
  tags {
    Name = "master-tf-${terraform.workspace}"
  }

}


resource "aws_instance" "infra" {
  ami           = "${var.image}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.zone}a"
  key_name          = "${var.key_name}"
  # subnet_id         = "${element(aws_subnet.openshift.*.id, 2)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 2)}"]

  tags {
    Name = "infra-tf-${terraform.workspace}"
  }

}



resource "aws_instance" "node" {
  count         = "${var.node_count}"
  ami           = "${var.image}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.zone}a"
  key_name          = "${var.key_name}"
  # subnet_id         = "${element(aws_subnet.openshift.*.id, 3)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 3)}"]
  tags {
    Name = "node-tf${format("%02d", count.index + 1)}-${terraform.workspace}"
  }

}



data "template_file" "openshift-inventory" {
  template = "${file("templates/openshift-inventory.tpl")}"

  vars {
    master_hosts   = "${join("\n","${aws_instance.master.*.private_dns}")}"
    master_url     = "${aws_instance.master.public_dns}"
    master_ips     = "${join("\n","${aws_instance.master.*.private_ip}")}"
    infra_hosts   = "${join("\n","${aws_instance.infra.*.private_dns}")}"
    infra_ips     = "${join("\n","${aws_instance.infra.*.private_ip}")}"
    node_hosts   = "${join("\n","${aws_instance.node.*.private_dns}")}"
    node_ips     = "${join("\n","${aws_instance.node.*.private_ip}")}"

  }
}
# network_interface_ids            = ["${module.network_interface.id[count.index]}"]


#
# "${element(data.azurerm_subnet.data_subnet.*.id, 1)}"

output "openshift-inventory" {
        value = "${data.template_file.openshift-inventory.*.rendered}"
}
