

resource "aws_s3_bucket" "buckets" {
    count = "${length(var.s3_buckets)}"
    bucket = "${var.s3_buckets[count.index]}"
    acl    = "private"  #default
    force_destroy = true
}