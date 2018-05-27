resource "google_compute_network" "atnetwork" {
  name                    = "atnetwork"
  auto_create_subnetworks = "true"
}

resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "${var.bastion_machine_type}"
  zone         = "${var.zone}"
  allow_stopping_for_update = "True"
  tags = ["openshift", "bastion"]

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "${google_compute_network.atnetwork.name}"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  provisioner "file" {
    connection {
      user = "ale"
   }

    source = "scripts/bastion.sh"
    destination = "/home/ale/bastion.sh"
  }

  provisioner "remote-exec" {

    connection {
      user = "ale"
      private_key = ""
    }

    inline = [
      "chmod +x /home/ale/bastion.sh",
      "/home/ale/bastion.sh",
    ]
  }
}



# metadata_startup_script = "sudo yum install -y git ansible pyOpenSSL python-cryptography python-lxml python-passlib httpd-tools java-1.8.0-openjdk-headless"


resource "google_compute_instance" "master" {
  count        = "${var.master_count}"
  name         = "atmaster${format("%02d", count.index + 1)}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  allow_stopping_for_update = "True"

  tags = ["openshift", "master","http-server","https-server"]

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "${google_compute_network.atnetwork.name}"

    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
}





resource "google_compute_instance" "infra" {
  count        = "${var.infra_count}"
  name         = "atinfra${format("%02d", count.index + 1)}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  allow_stopping_for_update = "True"

  tags = ["openshift", "infra","http-server","https-server"]

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "${google_compute_network.atnetwork.name}"

    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
}





resource "google_compute_instance" "node" {
  count        = "${var.node_count}"
  name         = "atnode${format("%02d", count.index + 1)}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  allow_stopping_for_update = "True"

  tags = ["openshift", "node"]

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "${google_compute_network.atnetwork.name}"

    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
}


data "template_file" "openshift-inventory" {
  count = "${var.master_count}"
  template = "${file("templates/openshift-inventory.tpl")}"

  vars {
    master_hosts   = "${join("\n","${google_compute_instance.master.*.name}")}"
    master_ips     = "${join("\n","${google_compute_instance.master.*.network_interface.0.address}")}"
    infra_hosts   = "${join("\n","${google_compute_instance.infra.*.name}")}"
    infra_ips     = "${join("\n","${google_compute_instance.infra.*.network_interface.0.address}")}"
    node_hosts   = "${join("\n","${google_compute_instance.node.*.name}")}"
    node_ips     = "${join("\n","${google_compute_instance.node.*.network_interface.0.address}")}"
    # infra_hosts    = "${join("\n",template_file.infra_ansible.*.rendered,openshift_hostname=openshift-infra-vm-0)}"
    # app_hosts     = "${join("\n",template_file.node_ansible.*.rendered,openshift_hostname=openshift-node-vm-0)}"  }
  }
}

output "openshift-inventory" {
        value = "${data.template_file.openshift-inventory.*.rendered}"
}

# master_hosts   = "${join("\n","${google_compute_instance.master.*.name}","openshift_ip=${google_compute_instance.master.network_interface.0.address} openshift_schedulable=true")}"

#
# "${element(module.google_compute_instance.master.*.id, 0)}"
# "${module.google_compute_instance.master.*.id}"
# openshift-master.c.first-project-200708.internal openshift_ip=10.164.0.2 openshift_schedulable=true

# vars {
#   master_hosts   = "${join("\n",template_file.master_ansible.*.rendered,openshift_hostname=openshift-master-vm-0)}"
#   infra_hosts    = "${join("\n",template_file.infra_ansible.*.rendered,openshift_hostname=openshift-infra-vm-0)}"
#   app_hosts     = "${join("\n",template_file.node_ansible.*.rendered,openshift_hostname=openshift-node-vm-0)}"  }
# }
