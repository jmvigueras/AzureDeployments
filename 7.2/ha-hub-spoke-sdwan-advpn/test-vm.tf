
// Setup for Server01 SpokeA
resource "azurerm_network_interface" "ni-vm-spokea" {
  name                = "${var.prefix}-ni-vm-spokea"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-spokea.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "vm-spokea" {
  name                            = "${var.prefix}-vm-spokea"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.ni-vm-spokea.id]

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
resource "azurerm_network_interface" "ni-vm-spokeb" {
  name                = "${var.prefix}-ni-vm-spokeb"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-spokeb.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "vm-spokeb" {
  name                            = "${var.prefix}-vm-spokeb"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.ni-vm-spokeb.id]

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

// Setup for Server01 SpokeC
resource "azurerm_network_interface" "ni-vm-spokec" {
  name                = "${var.prefix}-ni-vm-spokec"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-spokec.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "vm-spokec" {
  name                            = "${var.prefix}-vm-spokec"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.ni-vm-spokec.id]

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
