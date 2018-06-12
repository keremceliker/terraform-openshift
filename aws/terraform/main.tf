


resource "aws_instance" "bastion" {
  ami               = "${var.image}"
  instance_type     = "${var.bastion_instance_type}"
  availability_zone = "${var.zone}"
  key_name          = "${var.key_name}"
  subnet_id         = "${element(aws_subnet.openshift.*.id, 0)}"
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
  count             = "${var.master_count}"
  ami               = "${var.image}"
  instance_type     = "${var.instance_type}"
  availability_zone = "${var.zone}"
  key_name          = "${var.key_name}"
  subnet_id         = "${element(aws_subnet.openshift.*.id, 1)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 1)}"]

  root_block_device {
    volume_size = "${var.osdisk_size}"
  }


  tags {
    Name = "master-tf${format("%02d", count.index + 1)}-${terraform.workspace}"
    cluster-id = "${var.cluster_id}"
  }

}


resource "aws_instance" "infra" {
  count              = "${var.infra_count}"
  ami                = "${var.image}"
  instance_type      = "${var.instance_type}"
  availability_zone  = "${var.zone}"
  key_name           = "${var.key_name}"
  subnet_id         = "${element(aws_subnet.openshift.*.id, 2)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 2)}"]

  root_block_device {
    volume_size = "${var.osdisk_size}"
  }


  tags {
    Name = "infra-tf${format("%02d", count.index + 1)}-${terraform.workspace}"
    cluster-id = "${var.cluster_id}"
  }

}



resource "aws_instance" "node" {
  count         = "${var.node_count}"
  ami           = "${var.image}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.zone}"
  key_name          = "${var.key_name}"
  subnet_id         = "${element(aws_subnet.openshift.*.id, 3)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 3)}"]

  root_block_device {
    volume_size = "${var.osdisk_size}"
  }


  tags {
    Name = "node-tf${format("%02d", count.index + 1)}-${terraform.workspace}"
    cluster-id = "${var.cluster_id}"
  }

}
