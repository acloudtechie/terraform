variable "aws_key_path" {
    description = "Path to EC2 Key"
    default = "~/aws"
}
variable "aws_key_name" {
    description = "EC2 Key Pair Name"
    default = "bosh"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-da05a4a0" # ubuntu 16.04 LTS
    }
}

variable "vpc_name" {
    description = "Name for the VPC"
    default = "bosh-vpc"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "azs" {
    description = "AZs for the VPC"
    default = ["us-east-1a"]
}

variable "public_subnets" {
    description = "CIDR for the Public Subnets"
    default = ["10.0.0.0/24"]
}

variable "private_subnets" {
    description = "CIDR for the Private Subnet"
    default = ["10.0.101.0/24"]
}
