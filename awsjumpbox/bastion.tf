resource "aws_security_group" "bastion" {
  name = "jumpbox"
  description = "Jumpbox Security Group"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["${var.myip}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = "${file("user_data.sh")}"
}

/*  Terraform currently lacks the capability to manage the dynamically created ec2
    from auto scalling group, such as output instance ip, or allow file provisioning
*/
module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Launch configuration
  lc_name = "bastion-lc"

  image_id        = "${lookup(var.bastion_amis, var.aws_region)}"
  instance_type   = "${var.bastion_instance_type}"
  security_groups = ["${aws_security_group.bastion.id}"]
  user_data       = "${data.template_file.user_data.rendered}"
  key_name        = "${var.bastion_key_name}"

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "10"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "10"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "bastion-asg"
  vpc_zone_identifier       = ["${module.vpc.public_subnets}"]
  health_check_type         = "EC2"
  min_size                  = "1"
  max_size                  = "${length(module.vpc.public_subnets)}"
  desired_capacity          = "${length(module.vpc.public_subnets)}"
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    },
  ]
}

# Instance to test bastion access
/*
resource "aws_instance" "test" {
    count                  = "${length(var.private_subnets)}"
    ami                    = "${lookup(var.bastion_amis, var.aws_region)}"
    instance_type          = "${var.bastion_instance_type}"
    #iam_instance_profile  = "${var.iam_instance_profile}"
    subnet_id              = "${element(module.vpc.private_subnets, count.index)}"
    vpc_security_group_ids = ["${aws_security_group.bosh.id}"]
    user_data              = "${data.template_file.user_data.rendered}"
    key_name        = "${var.bastion_key_name}"
    depends_on = ["module.asg", "module.vpc"]
    lifecycle {
        create_before_destroy = true
    }
    tags {
        Name = "test-${count.index}"
    }
}
*/
/*
resource "aws_eip" "bastion" {
  count = "${length(var.public_subnets)}"
  vpc = true
}
*/