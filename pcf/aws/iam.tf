resource "aws_iam_user" "pcf" {
  name = "${var.pcf_user_name}"
  force_destroy = true
}

resource "aws_iam_access_key" "pcf" {
  user = "${aws_iam_user.pcf.name}"
}

resource "aws_iam_role" "pcf" {
  name = "${var.pcf_role_name}"
  assume_role_policy = "${file("assume-role-policy.json")}"
}

data "template_file" "pcf_policy" {
  template = "${file("pcfpolicy.json")}"
}

/*
resource "aws_iam_user_policy" "pcf" {
  name = "pcf_user_policy"
  user = "${aws_iam_user.pcf.name}"
  policy = "${data.template_file.pcf_policy.rendered}"
}
*/

resource "aws_iam_policy" "pcf" {
  name        = "pcf_policy"
  path        = "/"
  description = "PCF role policy"

  policy = "${data.template_file.pcf_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "role_attach" {
    role       = "${aws_iam_role.pcf.name}"
    policy_arn = "${aws_iam_policy.pcf.arn}"
}

resource "aws_iam_user_policy_attachment" "user-attach" {
    user       = "${aws_iam_user.pcf.name}"
    policy_arn = "${aws_iam_policy.pcf.arn}"
}