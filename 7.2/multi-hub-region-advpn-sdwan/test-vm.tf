// VM Region A VNET spoke 1
resource "azurerm_network_interface" "za-ni-vm-spoke-1" {
  name                = "${var.prefix}-za-ni-vm-spoke-1"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.vnet-fgt-regiona.subnets-spokes["n-spoke-vm-1_id"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "za-vm-spoke-1" {
  name                            = "${var.prefix}-za-vm-spoke-1"
  resource_group_name             = azurerm_resource_group.rg-regiona.name
  location                        = var.regiona
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.za-ni-vm-spoke-1.id]

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

// VM Region A VNET spoke 2
resource "azurerm_network_interface" "za-ni-vm-spoke-2" {
  name                = "${var.prefix}-za-ni-vm-spoke-2"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.vnet-fgt-regiona.subnets-spokes["n-spoke-vm-2_id"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "za-vm-spoke-2" {
  name                            = "${var.prefix}-za-vm-spoke-2"
  resource_group_name             = azurerm_resource_group.rg-regiona.name
  location                        = var.regiona
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.za-ni-vm-spoke-2.id]

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


// VM Region B VNET spoke 1
resource "azurerm_network_interface" "zb-ni-vm-spoke-1" {
  name                = "${var.prefix}-zb-ni-vm-spoke-1"
  location            = var.regionb
  resource_group_name = azurerm_resource_group.rg-regionb.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.vnet-fgt-regionb.subnets-spokes["n-spoke-vm-1_id"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "zb-vm-spoke-1" {
  name                            = "${var.prefix}-zb-vm-spoke-1"
  resource_group_name             = azurerm_resource_group.rg-regionb.name
  location                        = var.regionb
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.zb-ni-vm-spoke-1.id]

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

// VM Region B VNET spoke 2
resource "azurerm_network_interface" "zb-ni-vm-spoke-2" {
  name                = "${var.prefix}-zb-ni-vm-spoke-2"
  location            = var.regionb
  resource_group_name = azurerm_resource_group.rg-regionb.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.vnet-fgt-regionb.subnets-spokes["n-spoke-vm-2_id"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "zb-vm-spoke-2" {
  name                            = "${var.prefix}-zb-vm-spoke-2"
  resource_group_name             = azurerm_resource_group.rg-regionb.name
  location                        = var.regionb
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.zb-ni-vm-spoke-2.id]

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


// VM Region A VNET site
resource "azurerm_network_interface" "za-ni-vm-site-1" {
  name                = "${var.prefix}-za-ni-vm-site-1"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.vnet-site-regiona.subnets-site-peer["1_id"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_linux_virtual_machine" "za-vm-site-1" {
  name                            = "${var.prefix}-za-vm-site-1"
  resource_group_name             = azurerm_resource_group.rg-regiona.name
  location                        = var.regiona
  size                            = var.size-vm
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.za-ni-vm-site-1.id]

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
