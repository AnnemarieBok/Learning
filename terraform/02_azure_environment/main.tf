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

data "azurerm_subnet" "web" {
  name                 = "snet_web_dev"
  virtual_network_name = azurerm_virtual_network.vnet_dev.name
  resource_group_name  = azurerm_resource_group.rg_dev.name
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = data.azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.nsg_dev.id
}

resource "azurerm_network_interface" "nic_dev" {
	name = "nic_dev"
	resource_group_name = azurerm_resource_group.rg_dev.name
	location = var.location
  ip_configuration {
	name = "internal"
	subnet_id = data.azurerm_subnet.web.id
	private_ip_address_allocation = "Dynamic"
  }
  
}

resource "azurerm_linux_virtual_machine" "vm_dev" {
	name = "vm_dev"
	resource_group_name = azurerm_resource_group.rg_dev.name
	location = var.location
	size = "Standard_D4_v5"
	admin_username = "adminuser"
	network_interface_ids = [
	  azurerm_network_interface.nic_dev.id,
	]

  admin_ssh_key {
	username = "adminuser"
	public_key = file("~/.ssh/id_ed25519.pub")
  }

  os_disk {
	caching = "ReadWrite"
	storage_account_type = "Standard_LRS"
  }

  source_image_reference {
	publisher = "Canonical"
	offer     = "0001-com-ubuntu-server-jammy"
	sku       = "22_04-lts"
	version   = "latest"
  }
}