# resource "aws_instance" "glusterfs" {
#   count             = "${var.glusterfs_count}"
#   ami               = "${var.image}"
#   instance_type     = "${var.glusterfs_instance_type}"
#   availability_zone = "${var.zone}"
#   key_name          = "${var.key_name}"
#   subnet_id         = "${element(aws_subnet.openshift.*.id, 1)}"
#   associate_public_ip_address = true
#   vpc_security_group_ids = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 1)}"]
#
#   root_block_device {
#     volume_size = "${var.osdisk_size}"
#   }
#
#   tags {
#     Name = "glusterfs-tf${format("%02d", count.index + 1)}-${terraform.workspace}"
#   }
#
# }
#
#
resource "aws_ebs_volume" "glusterfs" {
  count             = "${var.glusterfs_count}"
  availability_zone = "${var.zone}"
  size              = 10
}

resource "aws_volume_attachment" "glusterfs" {
  count       = "${var.glusterfs_count}"
  device_name = "/dev/xvdb"
  volume_id   = "${aws_ebs_volume.glusterfs.*.id[count.index]}"
  instance_id = "${aws_instance.node.*.id[count.index]}"
}



# resource "aws_ebs_volume" "glusterfs_registry" {
#   count             = "${var.infra_count}"
#   availability_zone = "${var.zone}"
#   size              = 10
# }
#
# resource "aws_volume_attachment" "glusterfs_registry" {
#   count       = "${var.infra_count}"
#   device_name = "/dev/xvdb"
#   volume_id   = "${aws_ebs_volume.glusterfs_registry.*.id[count.index]}"
#   instance_id = "${aws_instance.infra.*.id[count.index]}"
# }
