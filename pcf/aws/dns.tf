/*
resource "aws_route53_zone" "pcf" {
  name = "mzpcf.com"
  force_destroy = true
}
*/

resource "aws_route53_record" "apps" {
  zone_id = "${var.zone_id}"
  name = "*.apps.mzpcf.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_lb.web.dns_name}"]
}

resource "aws_route53_record" "system" {
  zone_id = "${var.zone_id}"
  name = "*.system.mzpcf.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_lb.web.dns_name}"]
}

resource "aws_route53_record" "ssh" {
  zone_id = "${var.zone_id}"
  name = "ssh.mzpcf.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.ssh.dns_name}"]
}

resource "aws_route53_record" "tcp" {
  zone_id = "${var.zone_id}"
  name = "tcp.mzpcf.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.tcp.dns_name}"]
}

resource "aws_route53_record" "pcf" {
  zone_id = "${var.zone_id}"
  name = "pcf.mzpcf.com"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.opsman.public_ip}"]
}
