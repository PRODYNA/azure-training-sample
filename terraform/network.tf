
###################
# Virtual Network #
###################
resource "azurerm_virtual_network" "main" {
  name                = "VNET_${upper(var.user_name)}"
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.main.location
}

##########
# Subnet #
##########
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]

  service_endpoints = ["Microsoft.Sql"]
}

#######
# ASG #
#######
resource "azurerm_application_security_group" "web" {
  name                = "ASG_WEB"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

#######
# NSG #
#######
resource "azurerm_network_security_group" "web" {
  name                = "NSG_WEB"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_network_security_rule" "ssh" {
  name      = "SSH"
  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range     = "*"
  source_address_prefix = "*"

#   destination_address_prefix                 = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.web.id]
  destination_port_range                     = "22"

  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.web.name
}

resource "azurerm_network_security_rule" "http" {
  name      = "HTTP"
  priority  = 110
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range     = "*"
  source_address_prefix = "*"

#   destination_address_prefix                 = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.web.id]
  destination_port_range                     = "80"

  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.web.name
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.web.id
}

#############
# Public IP #
#############
resource "azurerm_public_ip" "web" {
  name                = "${lower(var.user_name)}-web"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  sku               = "Basic"
  allocation_method = "Static"
}