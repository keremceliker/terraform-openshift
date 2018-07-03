resource "aws_vpc" "openshift" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
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



resource "aws_internet_gateway" "openshift" {
  vpc_id = "${aws_vpc.openshift.id}"

  tags {
    Name = "${var.cluster_id}-${terraform.workspace}"
  }
}


### DEFAULT ROUTE TABLE PARA CUANDO USO IPS PUBLICAS
resource "aws_default_route_table" "openshift_igw" {
  default_route_table_id = "${aws_vpc.openshift.main_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.openshift.id}"
  }

  tags {
    Name = "${var.cluster_id}-${terraform.workspace}"
  }
}


# resource "aws_route_table" "openshift_igw" {
#   # default_route_table_id = "${aws_vpc.openshift.main_route_table_id}"
#   vpc_id = "${aws_vpc.openshift.id}"
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = "${aws_internet_gateway.openshift.id}"
#   }
#
#   tags {
#     Name = "${var.cluster_id}-${terraform.workspace}"
#   }
# }


### ASSOCIATION PARA CUANDO USO IPS PUBLICAS
resource "aws_route_table_association" "openshift_igw" {
  subnet_id      = "${element(aws_subnet.openshift.*.id, 0)}"
  route_table_id = "${aws_default_route_table.openshift_igw.id}"
}



# resource "aws_eip" "nat_gateway" {
#   vpc      = true
# }
#
#
# resource "aws_nat_gateway" "openshift_nat_gw" {
#   allocation_id  = "${aws_eip.nat_gateway.id}"
#   subnet_id      = "${element(aws_subnet.openshift.*.id, 1)}"
#   depends_on     = ["aws_internet_gateway.openshift"]
# }
#
#
#
#
#
# resource "aws_route_table" "openshift_nat_route" {
#   vpc_id = "${aws_vpc.openshift.id}"
#
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = "${aws_nat_gateway.openshift_nat_gw.id}"
#   }
#
#   # route {
#   #   ipv6_cidr_block = "::/0"
#   #   egress_only_gateway_id = "${aws_egress_only_internet_gateway.foo.id}"
#   # }
#
#   tags {
#     Name = "openshift-nat-${terraform.workspace}"
#   }
# }
#
#
# resource "aws_route_table_association" "openshift_nat" {
#   count          = 3
#   # subnet_id      = "${var.security_groups[count.index + 1]}"
#   subnet_id      = "${aws_subnet.openshift.*.id[count.index + 1]}"
#   route_table_id = "${aws_route_table.openshift_nat_route.id}"
# }
