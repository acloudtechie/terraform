# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}

# Elatic IP
output "eip" {
  description = "Elastic Public IP for Bosh Director"
  value       = ["${aws_eip.director.public_ip}"]
}

/*
output "bastion_eip" {
  description = "Elastic Public IP for Bastion servers"
  value       = ["${aws_eip.bastion.public_ip}"]
}
*/

# Security Group
output "bosh_sg" {
  description = "Security Group for Bosh"
  value       = ["${aws_security_group.bosh.id}"]
}