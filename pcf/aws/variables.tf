#######################
# Variables for main
#######################
variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

#######################
# Variables for s3
#######################
variable "s3_buckets" {
    description = "List of S3 buckets to be created"
    default = ["pcf-ops-manager-bucket-mz", "pcf-buildpacks-bucket-mz", "pcf-packages-bucket-mz", "pcf-resources-bucket-mz", "pcf-droplets-bucket-mz"]
}

#######################
# Variables for iam
#######################
variable "pcf_user_name" {
    description = "PCF User Name"
    default = "pcf-user"
}

variable "pcf_role_name" {
    description = "PCF User Name"
    default = "pcf-role"
}

#######################
# Variables for vpc
#######################
variable "name" {
    description = "Name for the VPC"
    default = "pcf-vpc"
}

variable "cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {
    Terraform = "true"
    Environment = "Dev"
  }
}

variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set"
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided"
  type        = "list"
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set"
  type        = "list"
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set"
  type        = "list"
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set"
  default     = ""
}

variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate"
  default     = []
}

variable "private_propagating_vgws" {
  description = "A list of VGWs the private route table should propagate"
  default     = []
}

variable "azs" {
    description = "AZs for the VPC"
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

/*
variable "public_subnets" {
    description = "CIDR for the Public Subnets"
    default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets_names" {
    description = "Names for the Public Subnets"
    default = ["pcf-public-subnet-az0", "pcf-public-subnet-az1", "pcf-public-subnet-az2"]
}
*/

variable "public_subnets" {
    description = "CIDR for the Public Subnets"
    default = {
        pcf-public-subnet-az0 = "10.0.0.0/24"
        pcf-public-subnet-az1 = "10.0.1.0/24"
        pcf-public-subnet-az2 = "10.0.2.0/24"
    }
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default     = true
}

/*
variable "private_subnets" {
    description = "CIDR for the Private Subnet"
    default = ["10.0.16.0/28", "10.0.16.16/28", "10.0.16.32/28", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" , "10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24", , "10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24"]
}

variable "private_subnets_names" {
    description = "Names for the Private Subnets"
    default = ["pcf-management-subnet-az0", "pcf-management-subnet-az1", "pcf-management-subnet-az2", "pcf-ert-subnet-az0", "pcf-ert-subnet-az1", "pcf-ert-subnet-az2", "pcf-services-subnet-az0", "pcf-services-subnet-az1", "pcf-services-subnet-az0", "pcf-rds-subnet-az0", "pcf-rds-subnet-az1", "pcf-rds-subnet-az2"]
}


variable "private_subnets" {
    description = "CIDR for the Private Subnets"
    default = {
        pcf-management-subnet-az0 = "10.0.16.0/28"
        pcf-management-subnet-az1 = "10.0.16.16/28"
        pcf-management-subnet-az2 = "10.0.16.32/28"
        pcf-ert-subnet-az0 = "10.0.4.0/24"
        pcf-ert-subnet-az1 = "10.0.5.0/24"
        pcf-ert-subnet-az2 = "10.0.6.0/24"
        pcf-services-subnet-az0 = "10.0.8.0/24"
        pcf-services-subnet-az1 = "10.0.9.0/24"
        pcf-services-subnet-az2 = "10.0.10.0/24"
        pcf-rds-subnet-az0 = "10.0.12.0/24"
        pcf-rds-subnet-az1 = "10.0.13.0/24"
        pcf-rds-subnet-az2 = "10.0.14.0/24"
    }
}
*/

variable "private_subnets" {
    description = "CIDR for the Private Subnets"
    default = {
        pcf-management-subnet-az0 = "10.0.16.0/28"
        pcf-management-subnet-az1 = "10.0.16.16/28"
        pcf-management-subnet-az2 = "10.0.16.32/28"
    }
}

variable "private_subnets_ert" {
    description = "CIDR for the Private Subnets"
    default = {
        pcf-ert-subnet-az0 = "10.0.4.0/24"
        pcf-ert-subnet-az1 = "10.0.5.0/24"
        pcf-ert-subnet-az2 = "10.0.6.0/24"
    }
}

variable "private_subnets_services" {
    description = "CIDR for the Private Subnets"
    default = {
        pcf-services-subnet-az0 = "10.0.8.0/24"
        pcf-services-subnet-az1 = "10.0.9.0/24"
        pcf-services-subnet-az2 = "10.0.10.0/24"
    }
}

variable "private_subnets_rds" {
    description = "CIDR for the Private Subnets"
    default = {
        pcf-rds-subnet-az0 = "10.0.12.0/24"
        pcf-rds-subnet-az1 = "10.0.13.0/24"
        pcf-rds-subnet-az2 = "10.0.14.0/24"
    }
}

variable "private_subnets_health" {
    description = "CIDR for the Health Check Subnets"
    default = {
        pcf-health-subnet-az0 = "10.0.20.0/24"
        pcf-health-subnet-az1 = "10.0.21.0/24"
        pcf-health-subnet-az2 = "10.0.22.0/24"
    }
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = false
}

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  default     = false
}

#######################
# Variables for sg
#######################
variable "myip" {
    description = "My IP to Restrict Access to"
    default = "100.36.36.248/32"
}

#######################
# Variables for opsman
#######################
variable "ops_amis" {
    description = "Ops Manager AMIs by region"
    default = {
        us-east-1 = "ami-687ffd12"
        us-east-2 = "ami-0a301e6f"
        us-west-1 = "ami-238db443"
        us-west-2 = "ami-67ed3e1f"
        us-gov-west-1 = "ami-3442ce55"
    }
}

variable "aws_key_name" {
    description = "EC2 Key Pair Name"
    default = "bosh"
}

variable "ops_instance_type" {
    description = "Ops Manager server instance type"
    default = "m4.large"
}

#######################
# Variables for rds
#######################
variable "mysql_version" {
    description = "MySQL Version"
    default = "5.6.37"
}

variable "mysql_instance_type" {
    description = "MySQL RDS Instance Type"
    default = "db.m3.large"
}

variable "mysql_iops" {
    description = "MySQL RDS IOPS"
    default = "1000"
}

#######################
# Route53
#######################
variable "zone_id" {
    description = "Route53 zone id"
    default = "Z2RVI9CS4PWJKU"
}
