provider "azurerm" {
  version = "~> 0.1"
}

resource "azurerm_resource_group" "boshresgroup" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags  = {
               environment = "${var.environment}"
               costcenter  = "${var.cost_center}"
            }
}

module "network" { 
    source              = "Azure/network/azurerm"
    resource_group_name = "${azurerm_resource_group.boshresgroup.name}"
    vnet_name           = "${var.vnet_name}"
    location            = "${var.location}"
    address_space       = "${var.vnet_cidr}"
    subnet_prefixes     = "${var.subnet_prefixes}"
    subnet_names        = "${var.subnet_names}"

    tags                = {
                            environment = "${var.environment}"
                            costcenter  = "${var.cost_center}"
                          }
}
resource "azurerm_public_ip" "one" {
  name                         = "boshpublicip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.boshresgroup.name}"
  public_ip_address_allocation = "static"

  tags  = {
               environment = "${var.environment}"
               costcenter  = "${var.cost_center}"
          }
}

resource "azurerm_network_security_group" "boshnsg" {
    name                = "${var.default_security_group}"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.boshresgroup.name}"

    security_rule {
      name                       = "ssh"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }

    security_rule {
      name                       = "bosh-agent"
      priority                   = 201
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6868"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    security_rule {
      name                       = "bosh-director"
      priority                   = 202
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "25555"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    security_rule {
      name                       = "dns"
      priority                   = 203
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

  tags  = {
               environment = "${var.environment}"
               costcenter  = "${var.cost_center}"
          }
}

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.boshresgroup.name}"
    }

    byte_length = 8
}

resource "azurerm_storage_account" "boshstore" {
    name                = "diag${random_id.randomId.hex}"
    #name                     = "${var.storage_account_name}"
    resource_group_name = "${azurerm_resource_group.boshresgroup.name}"
    location            = "${var.location}"
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags  = {
               environment = "${var.environment}"
               costcenter  = "${var.cost_center}"
            }
}

resource "azurerm_storage_container" "bosh" {
  name                  = "bosh"
  resource_group_name   = "${azurerm_resource_group.boshresgroup.name}"
  storage_account_name  = "${azurerm_storage_account.boshstore.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell" {
  name                  = "stemcell"
  resource_group_name   = "${azurerm_resource_group.boshresgroup.name}"
  storage_account_name  = "${azurerm_storage_account.boshstore.name}"
  container_access_type = "blob"
}

resource "local_file" "azurevars" {
    content = <<EOF
director_name: ${var.director_name}
internal_cidr: ${var.subnet_prefixes[0]}
internal_gw: ${cidrhost(var.subnet_prefixes[0], 1)}
internal_ip: ${cidrhost(var.subnet_prefixes[0], 6)}
vnet_name: ${module.network.vnet_name}
subnet_name: ${var.subnet_names[0]}
external_ip: ${azurerm_public_ip.one.ip_address}
resource_group_name: ${azurerm_resource_group.boshresgroup.name}
storage_account_name: ${azurerm_storage_account.boshstore.name}
default_security_group: ${azurerm_network_security_group.boshnsg.name}
    EOF
    filename = "${var.bosh_workspace_root_dir}/azure-vars.yml"
}
