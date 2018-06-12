data "template_file" "master-inventory" {
  count = "${var.master_count}"
  template = "${file("templates/hostname.tpl")}"
  vars {
    name  = "${aws_instance.master.*.private_dns[count.index]}"
    ip    = "${aws_instance.master.*.private_ip[count.index]}"
    data = "openshift_schedulable=true"
  }
}


data "template_file" "master-node-inventory" {
  count = "${var.master_count}"
  template = "${file("templates/hostname.tpl")}"
  vars {
    name  = "${aws_instance.master.*.private_dns[count.index]}"
    ip    = "${aws_instance.master.*.private_ip[count.index]}"
    data = "openshift_schedulable=true openshift_node_labels=\"{'region': 'primary', 'zone': 'east'}\""
  }
}

data "template_file" "etcd-inventory" {
  count = "${var.master_count}"
  template = "${file("templates/hostname.tpl")}"
  vars {
    name  = "${aws_instance.master.*.private_dns[count.index]}"
    ip    = "${aws_instance.master.*.private_ip[count.index]}"
    data = " "
  }
}



data "template_file" "node-inventory" {
  count = "${var.node_count}"
  template = "${file("templates/hostname.tpl")}"
  vars {
    name  = "${aws_instance.node.*.private_dns[count.index]}"
    ip    = "${aws_instance.node.*.private_ip[count.index]}"
    data = "openshift_schedulable=true openshift_node_labels=\"{'region': 'primary', 'zone': 'east'}\""
  }
}



data "template_file" "infra-inventory" {
  count = "${var.infra_count}"
  template = "${file("templates/hostname.tpl")}"
  vars {
    name  = "${aws_instance.infra.*.private_dns[count.index]}"
    ip    = "${aws_instance.infra.*.private_ip[count.index]}"
    data = "openshift_schedulable=true openshift_node_labels=\"{'region': 'infra', 'zone': 'default'}\""
  }
}




data "template_file" "openshift-inventory" {
  template = "${file("templates/openshift-inventory.tpl")}"
  vars {
    master_hosts          = "${join(" ",data.template_file.master-inventory.*.rendered)}"
    master_node_hosts     = "${join(" ",data.template_file.master-node-inventory.*.rendered)}"
    etcd_hosts            = "${join(" ",data.template_file.etcd-inventory.*.rendered)}"
    infra_hosts           = "${join(" ",data.template_file.infra-inventory.*.rendered)}"
    node_hosts            = "${join(" ",data.template_file.node-inventory.*.rendered)}"
    aws_access_key_id     = "${var.aws_access_key}"
    aws_secret_access_key = "${var.aws_secret_key}"
    cluster_id            = "${var.cluster_id}"
    console_domain        = "${var.console_domain}"
    # console_domain        = "${element(aws_instance.master.*.public_dns, 0)}"
  }
}



output "openshift-inventory" {
        # value = "${data.template_file.openshift-inventory.*.rendered}"
        # value = "${data.template_file.node-inventory.*.rendered}"
        value = "${data.template_file.openshift-inventory.rendered}"
}
