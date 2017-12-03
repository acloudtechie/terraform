resource "aws_iam_instance_profile" "ops" {
  name  = "ops_profile"
  role = "${aws_iam_role.pcf.name}"
}

resource "aws_instance" "opsman" {
    ami = "${lookup(var.ops_amis, var.aws_region)}"
    instance_type = "${var.ops_instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.ops.name}"
    subnet_id              = "${element(aws_subnet.public.*.id, 0)}"
    vpc_security_group_ids = ["${aws_security_group.ops.id}"]
    key_name        = "${var.aws_key_name}"

    lifecycle {
        create_before_destroy = true
    }
    root_block_device {
        volume_size = 100
        volume_type = "gp2"
    }
    tags = "${merge(var.tags, map("Name", format("%s", "pcf-ops-manager")))}"
}

