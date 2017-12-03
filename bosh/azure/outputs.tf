output "director_name" {
  description = "Bosh director name"
  value       = "${var.director_name}"
}

output "resource_group" {
  description = "resource group"
  value       = "${azurerm_resource_group.boshresgroup.id}"
}

output "vnet" {
  description = "VNet"
  value       = "${module.network.vnet_id}"
}

output "subnets" {
  description = "List of subnets"
  value       = "${module.network.vnet_subnets}"
}

output "director_public_ip" {
  description = "Public ip for the bosh director"
  value       = "${azurerm_public_ip.one.ip_address}"
}

output "storage_account" {
  description = "Storage account"
  value       = "${azurerm_storage_account.boshstore.id}"
}

# Security Group
output "sg" {
  description = "Security Group"
  value       = "${azurerm_network_security_group.boshnsg.id}"
}