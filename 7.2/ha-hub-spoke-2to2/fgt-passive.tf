resource "azurerm_image" "custom-fgt-passive" {
  count               = var.custom ? 1 : 0
  name                = var.custom_image_name
  resource_group_name = var.custom_image_resource_group_name
  location            = var.location
  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = var.customuri
    size_gb  = 2
  }
}

resource "azurerm_virtual_machine" "custom-fgt-passive" {
  count                        = var.custom ? 1 : 0
  name                         = "${var.prefix}-custom-fgt-passive"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.ni-passiveport1.id, azurerm_network_interface.ni-passiveport2.id, azurerm_network_interface.ni-passiveport3.id]
  primary_network_interface_id = azurerm_network_interface.ni-passiveport1.id
  vm_size                      = var.size

  storage_image_reference {
    id = var.custom ? element(azurerm_image.custom-fgt-passive.*.id, 0) : null
  }

  storage_os_disk {
    name              = "${var.prefix}-osDisk-custom-fgt-passive"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-datadisk-custom-fgt-passive"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "${var.prefix}-custom-fgt-passive"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.activeFortiGate.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.fgtstorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_virtual_machine" "fgt-passive" {
  count                        = var.custom ? 0 : 1
  name                         = "${var.prefix}-fgt-passive"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.ni-passiveport1.id, azurerm_network_interface.ni-passiveport2.id, azurerm_network_interface.ni-passiveport3.id]
  primary_network_interface_id = azurerm_network_interface.ni-passiveport1.id
  vm_size                      = var.size

  storage_image_reference {
    publisher = var.custom ? null : var.publisher
    offer     = var.custom ? null : var.fgtoffer
    sku       = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    version   = var.custom ? null : var.fgtversion
    id        = var.custom ? element(azurerm_image.custom-fgt-passive.*.id, 0) : null
  }

  plan {
    name      = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    publisher = var.publisher
    product   = var.fgtoffer
  }


  storage_os_disk {
    name              = "${var.prefix}-osDisk-fgt-passive"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-datadisk-fgt-passive"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgt-passive"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.passiveFortiGate.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.fgtstorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = var.tag_env
  }
}

data "template_file" "passiveFortiGate" {
  template = file(var.bootstrap-passive)
  vars = {
    type            = var.license_type
    license_file    = var.license
    port1_ip        = var.passiveport1
    port1_mask      = var.passiveport1mask
    port2_ip        = var.passiveport2
    port2_mask      = var.passiveport2mask
    port2_name      = azurerm_network_interface.ni-passiveport2.name
    port3_ip        = var.passiveport3
    port3_mask      = var.passiveport3mask
    port3_name      = azurerm_network_interface.ni-passiveport3.name
    active_peerip  = var.activeport1
    mgmt_gateway_ip = var.port1gateway
    defaultgwy      = var.port2gateway
    port3gateway    = var.port3gateway
    tenant          = var.tenant_id
    subscription    = var.subscription_id
    clientid        = var.client_id
    clientsecret    = var.client_secret
    adminsport      = var.adminsport
    rsg             = azurerm_resource_group.myterraformgroup.name
    clusterip       = azurerm_public_ip.cluster-ip.name
    vnetspokea      = azurerm_virtual_network.vnet-spokea.name
    vnetspokeb      = azurerm_virtual_network.vnet-spokeb.name
    spokeacidr      = var.spokeacidr
    spokebcidr      = var.spokebcidr
    
    routeprivate_name     = azurerm_route_table.rt-private.name
    routeprivate_route_0  = "default"
    routespoke_name       = azurerm_route_table.rt-spoke.name
//  routespoke_route_0    = azurerm_route.r-default-spokes.name
//  routespoke_route_1    = azurerm_route.r-spoke-to-spoke.name
//  routespoke_route_2    = azurerm_route.r-spoke-to-onprem.name
    routespoke_route_0    = "default"
    routespoke_route_1    = "spoke-to-spoke"
    routespoke_route_2    = "spoke-to-onprem"
  }
}
