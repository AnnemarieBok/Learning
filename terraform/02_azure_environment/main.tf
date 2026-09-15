resource "azurerm_resource_group" "rg_dev" {
	name = "rg_dev"
	location = var.location
}

# [to-do] Example online also shows a network security group. Figure out what this is.
	
resource "azurerm_virtual_network" "vnet_dev" {
	name = "vnet_dev"
	location = var.location
	resource_group_name = "rg_dev"
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