# Create a new load balancer
resource "aws_elb" "master" {
  name               = "${element(var.elb_names, 0)}-${terraform.workspace}"
  # availability_zones = ["${var.zone}"]
  # availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  security_groups    = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 1)}"]
  subnets            = ["${element(aws_subnet.openshift.*.id, 1 )}"]

  # access_logs {
  #   bucket        = "foo"
  #   bucket_prefix = "bar"
  #   interval      = 60
  # }

  # listener {
  #   instance_port     = 80
  #   instance_protocol = "http"
  #   lb_port           = 80
  #   lb_protocol       = "http"
  # }

  listener {
    instance_port      = 8443
    instance_protocol  = "tcp"
    lb_port            = 8443
    lb_protocol        = "tcp"
    # ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8443"
    interval            = 30
  }

  instances                   = ["${aws_instance.master.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${element(var.elb_names, 0)}-${terraform.workspace}"
  }
}




# Create a new load balancer
resource "aws_elb" "infra" {
  name               = "${element(var.elb_names, 1)}-${terraform.workspace}"
  # availability_zones = ["${var.zone}"]
  # availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  security_groups    = ["${data.aws_security_group.default.id}","${element(aws_security_group.sg_tf.*.id, 2)}"]
  subnets            = ["${element(aws_subnet.openshift.*.id, 2 )}"]

  # access_logs {
  #   bucket        = "foo"
  #   bucket_prefix = "bar"
  #   interval      = 60
  # }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 443
    instance_protocol  = "tcp"
    lb_port            = 443
    lb_protocol        = "tcp"
    # ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:443"
    interval            = 30
  }

  instances                   = ["${aws_instance.infra.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${element(var.elb_names, 1)}-${terraform.workspace}"
  }
}


data "aws_route53_zone" "mithrandir" {
  name         = "${var.hosted_zone}"
  # private_zone = true
}



resource "aws_route53_record" "openshift" {
  zone_id = "${data.aws_route53_zone.mithrandir.zone_id}"
  name    = "openshift-${terraform.workspace}"
  type    = "CNAME"
  ttl     = "300"

  records        = ["${aws_elb.master.dns_name}"]
}

resource "aws_route53_record" "openshift-apps" {
  zone_id = "${data.aws_route53_zone.mithrandir.zone_id}"
  name    = "*.openshift-${terraform.workspace}"
  type    = "CNAME"
  ttl     = "300"

  records        = ["${aws_elb.infra.dns_name}"]
}
