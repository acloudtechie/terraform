/*
resource "aws_iam_server_certificate" "pcf_cert" {
  name_prefix      = "pcf-cert"
  certificate_body = "${file("server.crt")}"
  private_key      = "${file("server.key")}"

  lifecycle {
    create_before_destroy = true
  }
}
*/

data "aws_acm_certificate" "mzpcf" {
  domain   = "*.mzpcf.com"
  statuses = ["ISSUED"]
}

/*
resource "aws_elb" "web" {
  name               = "pcf-web-elb"
  #availability_zones = "${var.azs}"
  security_groups = ["${aws_security_group.web_elb.id}"]
  subnets = ["${aws_subnet.public.*.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    #ssl_certificate_id = "${aws_iam_server_certificate.pcf_cert.arn}"
    ssl_certificate_id = "${data.aws_acm_certificate.mzpcf.arn}"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "tcp"
    lb_port            = 4443
    lb_protocol        = "ssl"
    #ssl_certificate_id = "${aws_iam_server_certificate.pcf_cert.arn}"
    ssl_certificate_id = "${data.aws_acm_certificate.mzpcf.arn}"
  }

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:8080/health"
    interval            = 5
  }
}
*/

resource "aws_lb" "web" {
  name            = "pcf-web-elb"
  security_groups = ["${aws_security_group.web_elb.id}"]
  subnets = ["${aws_subnet.public.*.id}"]
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "pcf-web-elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.this.id}"
  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 3
    timeout             = 3
    interval            = 5
    port                = 8080
    protocol            = "HTTP"
    path                = "/health"
    matcher             = 200
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.web.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.web_target_group.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.web.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${data.aws_acm_certificate.mzpcf.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.web_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_elb" "ssh" {
  name               = "pcf-ssh-elb"
  #availability_zones = "${var.azs}"
  security_groups = ["${aws_security_group.ssh_elb.id}"]
  subnets = ["${aws_subnet.public.*.id}"]

  listener {
    instance_port      = 2222
    instance_protocol  = "tcp"
    lb_port            = 2222
    lb_protocol        = "tcp"
  }

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 3
    timeout             = 3
    target              = "TCP:2222"
    interval            = 5
  }
}

resource "aws_elb" "tcp" {
  name               = "pcf-tcp-elb"
  #availability_zones = "${var.azs}"
  security_groups = ["${aws_security_group.tcp_elb.id}"]
  subnets = ["${aws_subnet.public.*.id}"]

  listener {
    instance_port      = 1024
    instance_protocol  = "tcp"
    lb_port            = 1024
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1025
    instance_protocol  = "tcp"
    lb_port            = 1025
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1026
    instance_protocol  = "tcp"
    lb_port            = 1026
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1027
    instance_protocol  = "tcp"
    lb_port            = 1027
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1028
    instance_protocol  = "tcp"
    lb_port            = 1028
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1029
    instance_protocol  = "tcp"
    lb_port            = 1029
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1030
    instance_protocol  = "tcp"
    lb_port            = 1030
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1031
    instance_protocol  = "tcp"
    lb_port            = 1031
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1032
    instance_protocol  = "tcp"
    lb_port            = 1032
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1033
    instance_protocol  = "tcp"
    lb_port            = 1033
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1034
    instance_protocol  = "tcp"
    lb_port            = 1034
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1035
    instance_protocol  = "tcp"
    lb_port            = 1035
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1036
    instance_protocol  = "tcp"
    lb_port            = 1036
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1037
    instance_protocol  = "tcp"
    lb_port            = 1037
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1038
    instance_protocol  = "tcp"
    lb_port            = 1038
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1039
    instance_protocol  = "tcp"
    lb_port            = 1039
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1040
    instance_protocol  = "tcp"
    lb_port            = 1040
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1041
    instance_protocol  = "tcp"
    lb_port            = 1041
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1042
    instance_protocol  = "tcp"
    lb_port            = 1042
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1043
    instance_protocol  = "tcp"
    lb_port            = 1043
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1044
    instance_protocol  = "tcp"
    lb_port            = 1044
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1045
    instance_protocol  = "tcp"
    lb_port            = 1045
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1046
    instance_protocol  = "tcp"
    lb_port            = 1046
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1047
    instance_protocol  = "tcp"
    lb_port            = 1047
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1048
    instance_protocol  = "tcp"
    lb_port            = 1048
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1049
    instance_protocol  = "tcp"
    lb_port            = 1049
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1050
    instance_protocol  = "tcp"
    lb_port            = 1050
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1051
    instance_protocol  = "tcp"
    lb_port            = 1051
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1052
    instance_protocol  = "tcp"
    lb_port            = 1052
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1053
    instance_protocol  = "tcp"
    lb_port            = 1053
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1054
    instance_protocol  = "tcp"
    lb_port            = 1054
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1055
    instance_protocol  = "tcp"
    lb_port            = 1055
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1056
    instance_protocol  = "tcp"
    lb_port            = 1056
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1057
    instance_protocol  = "tcp"
    lb_port            = 1057
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1058
    instance_protocol  = "tcp"
    lb_port            = 1058
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1059
    instance_protocol  = "tcp"
    lb_port            = 1059
    lb_protocol        = "tcp"
  }

    listener {
    instance_port      = 1060
    instance_protocol  = "tcp"
    lb_port            = 1060
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1061
    instance_protocol  = "tcp"
    lb_port            = 1061
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1062
    instance_protocol  = "tcp"
    lb_port            = 1062
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1063
    instance_protocol  = "tcp"
    lb_port            = 1063
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1064
    instance_protocol  = "tcp"
    lb_port            = 1064
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1065
    instance_protocol  = "tcp"
    lb_port            = 1065
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1066
    instance_protocol  = "tcp"
    lb_port            = 1066
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1067
    instance_protocol  = "tcp"
    lb_port            = 1067
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1068
    instance_protocol  = "tcp"
    lb_port            = 1068
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1069
    instance_protocol  = "tcp"
    lb_port            = 1069
    lb_protocol        = "tcp"
  }

    listener {
    instance_port      = 1070
    instance_protocol  = "tcp"
    lb_port            = 1070
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1071
    instance_protocol  = "tcp"
    lb_port            = 1071
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1072
    instance_protocol  = "tcp"
    lb_port            = 1072
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1073
    instance_protocol  = "tcp"
    lb_port            = 1073
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1074
    instance_protocol  = "tcp"
    lb_port            = 1074
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1075
    instance_protocol  = "tcp"
    lb_port            = 1075
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1076
    instance_protocol  = "tcp"
    lb_port            = 1076
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1077
    instance_protocol  = "tcp"
    lb_port            = 1077
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1078
    instance_protocol  = "tcp"
    lb_port            = 1078
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1079
    instance_protocol  = "tcp"
    lb_port            = 1079
    lb_protocol        = "tcp"
  }

    listener {
    instance_port      = 1080
    instance_protocol  = "tcp"
    lb_port            = 1080
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1081
    instance_protocol  = "tcp"
    lb_port            = 1081
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1082
    instance_protocol  = "tcp"
    lb_port            = 1082
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1083
    instance_protocol  = "tcp"
    lb_port            = 1083
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1084
    instance_protocol  = "tcp"
    lb_port            = 1084
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1085
    instance_protocol  = "tcp"
    lb_port            = 1085
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1086
    instance_protocol  = "tcp"
    lb_port            = 1086
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1087
    instance_protocol  = "tcp"
    lb_port            = 1087
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1088
    instance_protocol  = "tcp"
    lb_port            = 1088
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1089
    instance_protocol  = "tcp"
    lb_port            = 1089
    lb_protocol        = "tcp"
  }

    listener {
    instance_port      = 1090
    instance_protocol  = "tcp"
    lb_port            = 1090
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1091
    instance_protocol  = "tcp"
    lb_port            = 1091
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1092
    instance_protocol  = "tcp"
    lb_port            = 1092
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1093
    instance_protocol  = "tcp"
    lb_port            = 1093
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1094
    instance_protocol  = "tcp"
    lb_port            = 1094
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1095
    instance_protocol  = "tcp"
    lb_port            = 1095
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1096
    instance_protocol  = "tcp"
    lb_port            = 1096
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1097
    instance_protocol  = "tcp"
    lb_port            = 1097
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1098
    instance_protocol  = "tcp"
    lb_port            = 1098
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1099
    instance_protocol  = "tcp"
    lb_port            = 1099
    lb_protocol        = "tcp"
  }

    listener {
    instance_port      = 1100
    instance_protocol  = "tcp"
    lb_port            = 1100
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1101
    instance_protocol  = "tcp"
    lb_port            = 1101
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1102
    instance_protocol  = "tcp"
    lb_port            = 1102
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1103
    instance_protocol  = "tcp"
    lb_port            = 1103
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1104
    instance_protocol  = "tcp"
    lb_port            = 1104
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1105
    instance_protocol  = "tcp"
    lb_port            = 1105
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1106
    instance_protocol  = "tcp"
    lb_port            = 1106
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1107
    instance_protocol  = "tcp"
    lb_port            = 1107
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1108
    instance_protocol  = "tcp"
    lb_port            = 1108
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1109
    instance_protocol  = "tcp"
    lb_port            = 1109
    lb_protocol        = "tcp"
  }

    listener {
    instance_port      = 1110
    instance_protocol  = "tcp"
    lb_port            = 1110
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1111
    instance_protocol  = "tcp"
    lb_port            = 1111
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1112
    instance_protocol  = "tcp"
    lb_port            = 1112
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1113
    instance_protocol  = "tcp"
    lb_port            = 1113
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1114
    instance_protocol  = "tcp"
    lb_port            = 1114
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1115
    instance_protocol  = "tcp"
    lb_port            = 1115
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1116
    instance_protocol  = "tcp"
    lb_port            = 1116
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1117
    instance_protocol  = "tcp"
    lb_port            = 1117
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1118
    instance_protocol  = "tcp"
    lb_port            = 1118
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1119
    instance_protocol  = "tcp"
    lb_port            = 1119
    lb_protocol        = "tcp"
  }

    listener {
    instance_port      = 1120
    instance_protocol  = "tcp"
    lb_port            = 1120
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1121
    instance_protocol  = "tcp"
    lb_port            = 1121
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1122
    instance_protocol  = "tcp"
    lb_port            = 1122
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 1123
    instance_protocol  = "tcp"
    lb_port            = 1123
    lb_protocol        = "tcp"
  }

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 3
    timeout             = 3
    target              = "TCP:80"
    interval            = 5
  }
}