resource "aws_db_subnet_group" "pcf" {
  name       = "pcf-rds-subnet-group"
  subnet_ids = ["${aws_subnet.rds.*.id}"]

  tags {
    Name = "PCF DB subnet group"
  }
}

resource "aws_db_instance" "pcf" {
  allocated_storage    = 100
  storage_type         = "io1"
  iops                 = "${var.mysql_iops}"
  engine               = "mysql"
  engine_version       = "${var.mysql_version}"
  instance_class       = "${var.mysql_instance_type}"
  identifier           = "pcf-ops-manager-director"
  name                 = "bosh"
  username             = "admin"
  password             = "adminadmin"
  db_subnet_group_name = "${aws_db_subnet_group.pcf.name}"
  multi_az = "true"
  vpc_security_group_ids = ["${aws_security_group.mysql.id}"]
  skip_final_snapshot = true
  #final_snapshot_identifier = "pcf-final-snapshot"
}