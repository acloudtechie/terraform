resource "aws_security_group" "ops" {
  name = "pcf-ops-manager-security-group"
  description = "Ops Manager Security Group"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "TCP"
    cidr_blocks = ["${var.myip}"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["${var.myip}"]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["${var.myip}"]
  }
  ingress {
    from_port   = "6868"
    to_port     = "6868"
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr}"]
  }
  ingress {
    from_port   = "25555"
    to_port     = "25555"
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(var.tags,map("Name", format("%s-sg-%s", var.name, "ops")))}"
}

resource "aws_security_group" "vms" {
  name = "pcf-vms-security-group"
  description = "PCF VMs Security Group"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port = "0"
    to_port = "65535"
    protocol = "TCP"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(var.tags,map("Name", format("%s-sg-%s", var.name, "vms")))}"
}

resource "aws_security_group" "web_elb" {
  name = "pcf-web-elb-security-group"
  description = "Web ELB Security Group"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port = "4443"
    to_port = "4443"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "443"
    to_port = "443"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(var.tags,map("Name", format("%s-sg-%s", var.name, "web_elb")))}"
}

resource "aws_security_group" "ssh_elb" {
  name = "pcf-ssh-elb-security-group"
  description = "SSH ELB Security Group"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port = "2222"
    to_port = "2222"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(var.tags,map("Name", format("%s-sg-%s", var.name, "ssh_elb")))}"
}

resource "aws_security_group" "tcp_elb" {
  name = "pcf-tcp-elb-security-group"
  description = "TCP ELB Security Group"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port = "1024"
    to_port = "1123"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(var.tags,map("Name", format("%s-sg-%s", var.name, "tcp_elb")))}"
}

resource "aws_security_group" "nat" {
  name = "pcf-nat-security-group"
  description = "NAT Security Group"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port = "0"
    to_port = "65535"
    protocol = "TCP"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(var.tags,map("Name", format("%s-sg-%s", var.name, "nat")))}"
}

resource "aws_security_group" "mysql" {
  name = "MySQL"
  description = "Mysql RDS Security Group"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port = "3306"
    to_port = "3306"
    protocol = "TCP"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.cidr}"]
  }
  tags = "${merge(var.tags,map("Name", format("%s-sg-%s", var.name, "mysql")))}"
}