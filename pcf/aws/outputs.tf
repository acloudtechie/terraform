/*
output "pcf_user" {
  value = "ACCESS_KEY: ${aws_iam_access_key.pcf.id}, SECRET: ${aws_iam_access_key.pcf.secret}"
}
*/

# VPC
output "vpc_id" {
  description = "The ID of the PCF VPC"
  value       = "${aws_vpc.this.id}"
}

# Security Group
output "pcf-vms-security-group" {
  description = "Security Group for pcf-vms-security-group"
  value       = ["${aws_security_group.vms.id}"]
}

# RDS
output "rds endpoint" {
  description = "RDS endpoint"
  value       = ["${aws_db_instance.pcf.endpoint}"]
}

# Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  #value       = ["${aws_subnet.public.*.id}"]
  value       = "${formatlist("%s : %s : %s", aws_subnet.public.*.id, aws_subnet.public.*.cidr_block, aws_subnet.public.*.availability_zone )}"
}

output "mgmt_subnets" {
  description = "List of IDs of private mgmt subnets"
  #value       = ["${aws_subnet.private.*.id}"]
  value       = "${formatlist("%s : %s : %s", aws_subnet.private.*.id, aws_subnet.private.*.cidr_block, aws_subnet.private.*.availability_zone )}"
}

output "ert_subnets" {
  description = "List of IDs of private ert subnets"
  #value       = ["${aws_subnet.ert.*.id}"]
  value       = "${formatlist("%s : %s : %s", aws_subnet.ert.*.id, aws_subnet.ert.*.cidr_block, aws_subnet.ert.*.availability_zone )}"
}

output "services_subnets" {
  description = "List of IDs of private services subnets"
  #value       = ["${aws_subnet.services.*.id}"]
  value       = "${formatlist("%s : %s : %s", aws_subnet.services.*.id, aws_subnet.services.*.cidr_block, aws_subnet.services.*.availability_zone )}"
}

output "rds_subnets" {
  description = "List of IDs of private ert subnets"
  value       = "${formatlist("%s : %s : %s", aws_subnet.rds.*.id, aws_subnet.rds.*.cidr_block, aws_subnet.rds.*.availability_zone )}"
}

output "health_subnets" {
  description = "List of IDs of private health check subnets"
  value       = "${formatlist("%s : %s : %s", aws_subnet.health.*.id, aws_subnet.health.*.cidr_block, aws_subnet.health.*.availability_zone )}"
}