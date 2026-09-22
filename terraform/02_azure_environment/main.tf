resource "azurerm_resource_group" "rg_dev" {
	name = "rg_dev"
	location = var.location
}

# [to-do] Example online also shows a network security group. Figure out what this is. (Exists within the same resource group. Defines the security rules, can then be associated to the subnet. Everything is denied by default)
resource "azurerm_network_security_group" "nsg_dev" {
	name = "nsg_dev"
	location = var.location
	resource_group_name = azurerm_resource_group.rg_dev.name

  security_rule {
	name = "allowHTTPS"
	priority = 100
	direction = "Inbound"
	access = "Allow"
	protocol = "Tcp"
	source_port_range = "*"
	destination_port_range = "443"
	source_address_prefix = "*"
	destination_address_prefix = "*"
  }

  security_rule {
	name = "allowHTTP"
	priority = 110
	direction = "Inbound"
	access = "Allow"
	protocol = "Tcp"
	source_port_range = "*"
	destination_port_range = "80"
	source_address_prefix = "*"
	destination_address_prefix = "*"
  }
}
	
resource "azurerm_virtual_network" "vnet_dev" {
	name = "vnet_dev"
	location = var.location
	resource_group_name = azurerm_resource_group.rg_dev.name
	address_space = ["10.0.0.0/16"]
	
  subnet {
	name = "snet_web_dev"
	address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
	name = "snet_app_dev"
	address_prefixes = ["10.0.2.0/24"]
  }

}