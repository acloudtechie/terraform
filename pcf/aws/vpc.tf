######
# VPC
######
resource "aws_vpc" "this" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

###################
# DHCP Options Set
###################
resource "aws_vpc_dhcp_options" "this" {
  count = "${var.enable_dhcp_options ? 1 : 0}"

  domain_name          = "${var.dhcp_options_domain_name}"
  domain_name_servers  = "${var.dhcp_options_domain_name_servers}"
  ntp_servers          = "${var.dhcp_options_ntp_servers}"
  netbios_name_servers = "${var.dhcp_options_netbios_name_servers}"
  netbios_node_type    = "${var.dhcp_options_netbios_node_type}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

###############################
# DHCP Options Set Association
###############################
resource "aws_vpc_dhcp_options_association" "this" {
  count = "${var.enable_dhcp_options ? 1 : 0}"

  vpc_id          = "${aws_vpc.this.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.this.id}"
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  count = "${length(var.public_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

################
# Publiс routes
################
resource "aws_route_table" "public" {
  count = "${length(var.public_subnets) > 0 ? 1 : 0}"

  vpc_id           = "${aws_vpc.this.id}"
  propagating_vgws = ["${var.public_propagating_vgws}"]

  tags = "${merge(var.tags, map("Name", format("%s-public", var.name)))}"
}

resource "aws_route" "public_internet_gateway" {
  count = "${length(var.public_subnets) > 0 ? 1 : 0}"

  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this.id}"
}

#################
# Private routes
#################
resource "aws_route_table" "private" {
  count = "${length(var.azs)}"

  vpc_id           = "${aws_vpc.this.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]

  tags = "${merge(var.tags, map("Name", format("%s-mgmt-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_route_table" "ert" {
  count = "${length(var.azs)}"

  vpc_id           = "${aws_vpc.this.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]

  tags = "${merge(var.tags, map("Name", format("%s-ert-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_route_table" "services" {
  count = "${length(var.azs)}"

  vpc_id           = "${aws_vpc.this.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]

  tags = "${merge(var.tags, map("Name", format("%s-services-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_route_table" "rds" {
  count = "${length(var.azs)}"

  vpc_id           = "${aws_vpc.this.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]

  tags = "${merge(var.tags, map("Name", format("%s-rds-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_route_table" "health" {
  count = "${length(var.azs)}"

  vpc_id           = "${aws_vpc.this.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]

  tags = "${merge(var.tags, map("Name", format("%s-health-%s", var.name, element(var.azs, count.index))))}"
}

################
# Public subnet
################
resource "aws_subnet" "public" {
  count = "${length(var.public_subnets)}"

  vpc_id                  = "${aws_vpc.this.id}"
  cidr_block              = "${element(values(var.public_subnets), count.index)}"
  availability_zone       = "${element(var.azs, count.index % length(var.azs))}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags = "${merge(var.tags, map("Name", format("%s", element(keys(var.public_subnets), count.index))))}"
}

#################
# Private subnet
#################
resource "aws_subnet" "private" {
  count = "${length(var.private_subnets)}"

  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${element(values(var.private_subnets), count.index)}"
  availability_zone = "${element(var.azs, count.index % length(var.azs))}"

  tags = "${merge(var.tags, map("Name", format("%s", element(keys(var.private_subnets), count.index))))}"
}

resource "aws_subnet" "ert" {
  count = "${length(var.private_subnets_ert)}"

  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${element(values(var.private_subnets_ert), count.index)}"
  availability_zone = "${element(var.azs, count.index % length(var.azs))}"

  tags = "${merge(var.tags, map("Name", format("%s", element(keys(var.private_subnets_ert), count.index))))}"
}

resource "aws_subnet" "services" {
  count = "${length(var.private_subnets_services)}"

  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${element(values(var.private_subnets_services), count.index)}"
  availability_zone = "${element(var.azs, count.index % length(var.azs))}"

  tags = "${merge(var.tags, map("Name", format("%s", element(keys(var.private_subnets_services), count.index))))}"
}

resource "aws_subnet" "rds" {
  count = "${length(var.private_subnets_rds)}"

  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${element(values(var.private_subnets_rds), count.index)}"
  availability_zone = "${element(var.azs, count.index % length(var.azs))}"

  tags = "${merge(var.tags, map("Name", format("%s", element(keys(var.private_subnets_rds), count.index))))}"
}

resource "aws_subnet" "health" {
  count = "${length(var.private_subnets_health)}"

  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${element(values(var.private_subnets_health), count.index)}"
  availability_zone = "${element(var.azs, count.index % length(var.azs))}"

  tags = "${merge(var.tags, map("Name", format("%s", element(keys(var.private_subnets_health), count.index))))}"
}

##############
# NAT Gateway
##############
resource "aws_eip" "nat" {
  count = "${var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0}"

  vpc = true
}

resource "aws_nat_gateway" "this" {
  count = "${var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0}"

  allocation_id = "${element(aws_eip.nat.*.id, (var.single_nat_gateway ? 0 : count.index))}"
  subnet_id     = "${element(aws_subnet.public.*.id, (var.single_nat_gateway ? 0 : count.index))}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.name, element(var.azs, (var.single_nat_gateway ? 0 : count.index)))))}"

  depends_on = ["aws_internet_gateway.this"]
}

resource "aws_route" "private_nat_gateway" {
  count = "${var.enable_nat_gateway ? length(var.azs) : 0}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.this.*.id, count.index)}"
}

resource "aws_route" "ert_nat_gateway" {
  count = "${var.enable_nat_gateway ? length(var.azs) : 0}"

  route_table_id         = "${element(aws_route_table.ert.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.this.*.id, count.index)}"
}

resource "aws_route" "services_nat_gateway" {
  count = "${var.enable_nat_gateway ? length(var.azs) : 0}"

  route_table_id         = "${element(aws_route_table.services.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.this.*.id, count.index)}"
}

resource "aws_route" "rds_nat_gateway" {
  count = "${var.enable_nat_gateway ? length(var.azs) : 0}"

  route_table_id         = "${element(aws_route_table.rds.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.this.*.id, count.index)}"
}

resource "aws_route" "health_nat_gateway" {
  count = "${var.enable_nat_gateway ? length(var.azs) : 0}"

  route_table_id         = "${element(aws_route_table.health.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.this.*.id, count.index)}"
}
######################
# VPC Endpoint for S3
######################
data "aws_vpc_endpoint_service" "s3" {
  count = "${var.enable_s3_endpoint}"

  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = "${var.enable_s3_endpoint}"

  vpc_id       = "${aws_vpc.this.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = "${var.enable_s3_endpoint ? length(var.private_subnets) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_vpc_endpoint_route_table_association" "ert_s3" {
  count = "${var.enable_s3_endpoint ? length(var.private_subnets_ert) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${element(aws_route_table.ert.*.id, count.index)}"
}

resource "aws_vpc_endpoint_route_table_association" "services_s3" {
  count = "${var.enable_s3_endpoint ? length(var.private_subnets_services) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${element(aws_route_table.services.*.id, count.index)}"
}

resource "aws_vpc_endpoint_route_table_association" "rds_s3" {
  count = "${var.enable_s3_endpoint ? length(var.private_subnets_rds) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${element(aws_route_table.rds.*.id, count.index)}"
}

resource "aws_vpc_endpoint_route_table_association" "health_s3" {
  count = "${var.enable_s3_endpoint ? length(var.private_subnets_health) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${element(aws_route_table.health.*.id, count.index)}"
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = "${var.enable_s3_endpoint ? length(var.public_subnets) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.public.id}"
}

##########################
# Route table association
##########################
resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "ert" {
  count = "${length(var.private_subnets_ert)}"

  subnet_id      = "${element(aws_subnet.ert.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.ert.*.id, count.index)}"
}

resource "aws_route_table_association" "services" {
  count = "${length(var.private_subnets_services)}"

  subnet_id      = "${element(aws_subnet.services.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.services.*.id, count.index)}"
}

resource "aws_route_table_association" "rds" {
  count = "${length(var.private_subnets_rds)}"

  subnet_id      = "${element(aws_subnet.rds.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.rds.*.id, count.index)}"
}

resource "aws_route_table_association" "health" {
  count = "${length(var.private_subnets_health)}"

  subnet_id      = "${element(aws_subnet.health.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.health.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

##############
# VPN Gateway
##############
resource "aws_vpn_gateway" "this" {
  count = "${var.enable_vpn_gateway ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}