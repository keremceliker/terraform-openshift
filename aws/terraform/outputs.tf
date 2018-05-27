
output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip }"
}

output "master_public_dns" {
  value = "${aws_instance.master.public_dns }"
}
