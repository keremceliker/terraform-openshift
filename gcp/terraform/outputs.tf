

output "bastion_name" {
  value = "${google_compute_instance.bastion.name}"
}

output "bastion_public_ip" {
  value = "${google_compute_instance.bastion.network_interface.0.access_config.0.assigned_nat_ip }"
}



output "master_name" {
  value = "${google_compute_instance.master.*.name}"
}

output "master_public_ip" {
  value = "${google_compute_instance.master.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "master_private_ip" {
  value = "${google_compute_instance.master.network_interface.0.address}"
}


output "infra_name" {
  value = "${google_compute_instance.infra.*.name}"
}

output "infra_private_ip" {
  value = "${google_compute_instance.infra.network_interface.0.address}"
}


output "node_name" {
  value = "${google_compute_instance.node.*.name}"
}

output "node_private_ip" {
  value = "${google_compute_instance.node.network_interface.0.address}"
}
