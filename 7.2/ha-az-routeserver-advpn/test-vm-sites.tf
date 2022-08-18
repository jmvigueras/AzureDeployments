
// Setup for Server01 in site1

resource "azurerm_network_interface" "ni-vm-site1" {
  name                = "${var.prefix}-ni-vm-site1"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-internal-site1.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "vm-site1" {
  name                            = "${var.prefix}-vm-site1"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.ni-vm-site1.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}


// Setup for Server01 in site2

resource "azurerm_network_interface" "ni-vm-site2" {
  name                = "${var.prefix}-ni-vm-site2"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-internal-site2.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "vm-site2" {
  name                            = "${var.prefix}-vm-site2"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.ni-vm-site2.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
