
// Setup for Server01 SpokeA
resource "azurerm_network_interface" "ip01spokeaserver01" {
  name                = "ip01spokeAserver01"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ip01spokeAsubnet"
    subnet_id                     = azurerm_subnet.spokeasubnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "Terraform Demo"
  }
}


resource "azurerm_linux_virtual_machine" "server01spokea" {
  name                            = "server01spokeA"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.ip01spokeaserver01.id,
  ]

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

// Setup for Server01 SpokeB
resource "azurerm_network_interface" "ip01spokebserver01" {
  name                = "ip01spokeBserver01"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ip01spokeBsubnet"
    subnet_id                     = azurerm_subnet.spokebsubnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "Terraform Demo"
  }
}


resource "azurerm_linux_virtual_machine" "server01spokeb" {
  name                            = "server01spokeB"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.ip01spokebserver01.id,
  ]

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


