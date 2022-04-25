#########################
# Ref to Resource Group #
#########################
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

###################
# Virtual machine #
###################
resource "azurerm_network_interface" "vm" {
  name                = "nic-wordpress-1-${var.instance_id}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.pip_id
  }
}

resource "azurerm_network_interface_application_security_group_association" "vm" {
  network_interface_id          = azurerm_network_interface.vm.id
  application_security_group_id = var.asg_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm-wordpress-1-${var.instance_id}"
  location                        = data.azurerm_resource_group.main.location
  resource_group_name             = data.azurerm_resource_group.main.name
  size                            = "Standard_B2s"
  admin_username                  = "trainingadmin"
  admin_password                  = "mysecret123!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
