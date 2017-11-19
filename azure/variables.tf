variable "resource_group_name" {
    description = "Azure Resource Group Name"
    default = "bosh-res-group"
}

variable "location" {
    description = "Azure Resource Location"
    default = "East US"
}

variable "vnet_name" {
    description = "Name for the VNET"
    default = "boshvnet-crp"
}

variable "vnet_cidr" {
    description = "CIDR for the whole VNET"
    default = "10.0.0.0/16"
}
variable "subnet_prefixes" {
    description = "CIDRs for the Subnets"
    default = ["10.0.0.0/24"]
}

variable "subnet_names" {
    description = "Names for the Subnets"
    default = ["bosh"]
}

variable "storage_account_name" {
    description = "Names for the Story Account Name"
    default = "boshstore"
}

variable "default_security_group" {
    description = "Default security group name"
    default = "nsg-bosh"
}

variable "environment" {
    description = "Environment Tag"
    default = "dev"
}

variable "cost_center" {
    description = "Cost Center"
    default = "pre"
}

variable "director_name" {
    description = "Name of bosh direcotor"
    default = "bosh-azure"
}

variable "bosh_workspace_root_dir" {
    description = "Directory to export AWS Variables"
    default = "/tmp/bosh"
}