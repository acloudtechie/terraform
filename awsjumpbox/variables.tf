variable "aws_bastion_key_path" {
    description = "Path to EC2 Key"
    default = "~/.ssh/aws_bastion"
}
variable "bosh_key_name" {
    description = "EC2 Key Pair Name for Bosh director"
    default = "bosh"
}

variable "bastion_key_name" {
    description = "EC2 Key Pair Name for bastion servers"
    default = "bastion"
}

variable "myip" {
    description = "My IP to Restrict Access to"
    default = "100.36.36.248/32"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "bastion_amis" {
    description = "Bastion AMIs by region"
    default = {
        #us-east-1 = "ami-da05a4a0" # ubuntu 16.04 LTS
        us-east-1 = "ami-6057e21a" # amazon linux ami
    }
}

variable "bastion_instance_type" {
    description = "Bastion server instance type"
    default = "t2.micro"
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
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
    description = "CIDR for the Public Subnets"
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_subnets" {
    description = "CIDR for the Private Subnet"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "environment" {
    description = "Environment tag"
    default = "dev"
}

variable "bosh_aws_vars_file_path" {
    description = "Path to exported AWS Variables file"
    default = "/tmp/bosh/aws-vars.yml"
}

variable "provisioner_ssh_user" {
    description = "ssh user for provisioner connection"
    default = "ec2-user"
}