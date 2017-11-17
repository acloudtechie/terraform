provider "aws" {
    region = "${var.aws_region}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"
  
  azs             = "${var.azs}"
  public_subnets = "${var.public_subnets}"
  #private_subnets = "${var.private_subnets}"

  enable_dns_hostnames = true
  enable_dns_support = true
  
  #enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "bosh"
  }
}

resource "aws_eip" "one" {
  vpc = true
}

resource "aws_security_group" "bosh" {
  name = "bosh"
  description = "Bosh Security Group"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["${var.myip}"]
  }
  ingress {
    from_port   = "6868"
    to_port     = "6868"
    protocol    = "TCP"
    cidr_blocks = ["${var.myip}"]
  }
  ingress {
    from_port   = "25555"
    to_port     = "25555"
    protocol    = "TCP"
    cidr_blocks = ["${var.myip}"]
  }

  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "TCP"
    self = true
  }

  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "UDP"
    self = true
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "local_file" "awsvars" {
    content = <<EOF
director_name: bosh-aws
internal_cidr: ${var.public_subnets[0]}
internal_gw: ${cidrhost(var.public_subnets[0], 1)}
internal_ip: ${cidrhost(var.public_subnets[0], 7)}
region: ${var.aws_region}
az: ${var.azs[0]}
default_key_name: ${var.aws_key_name}
subnet_id: ${module.vpc.public_subnets[0]}
external_ip: ${aws_eip.one.public_ip}
default_security_groups: [${aws_security_group.bosh.id}]
    EOF
    filename = "${var.var_export_file}"
}
