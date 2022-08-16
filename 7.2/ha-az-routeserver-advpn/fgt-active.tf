resource "azurerm_image" "custom" {
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

resource "azurerm_virtual_machine" "custom-fgt-active" {
  count                        = var.custom ? 1 : 0
  name                         = "${var.prefix}-custom-fgt-active"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.ni-activeport1.id, azurerm_network_interface.ni-activeport2.id, azurerm_network_interface.ni-activeport3.id, azurerm_network_interface.ni-activeport4.id]
  primary_network_interface_id = azurerm_network_interface.ni-activeport1.id
  vm_size                      = var.size

  storage_image_reference {
    id = var.custom ? element(azurerm_image.custom.*.id, 0) : null
  }

  storage_os_disk {
    name              = "${var.prefix}-osDisk-custom-fgt-active"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-datadisk-custom-fgt-active"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "${var.prefix}-custom-fgt-active"
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

resource "azurerm_virtual_machine" "fgt-active" {
  count                        = var.custom ? 0 : 1
  name                         = "${var.prefix}-fgt-active"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.ni-activeport1.id, azurerm_network_interface.ni-activeport2.id, azurerm_network_interface.ni-activeport3.id, azurerm_network_interface.ni-activeport4.id]
  primary_network_interface_id = azurerm_network_interface.ni-activeport1.id
  vm_size                      = var.size

  storage_image_reference {
    publisher = var.custom ? null : var.publisher
    offer     = var.custom ? null : var.fgtoffer
    sku       = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    version   = var.custom ? null : var.fgtversion
    id        = var.custom ? element(azurerm_image.custom.*.id, 0) : null
  }

  plan {
    name      = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    publisher = var.publisher
    product   = var.fgtoffer
  }


  storage_os_disk {
    name              = "${var.prefix}-osDisk-fgt-active"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-datadisk-fgt-active"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgt-active"
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

data "template_file" "activeFortiGate" {
  template = file(var.bootstrap-active)
  vars = {
    type            = var.license_type
    license_file    = var.license
    port1_ip        = var.activeport1
    port1_mask      = var.activeport1mask
    port1_gw        = var.port1gateway
    port2_ip        = var.activeport2
    port2_mask      = var.activeport2mask
    port2_name      = azurerm_network_interface.ni-activeport2.name
    port2_gw        = var.port2gateway
    port3_ip        = var.activeport3
    port3_mask      = var.activeport3mask
    port3_name      = azurerm_network_interface.ni-activeport3.name
    port3_gw        = var.port3gateway
    port4_ip        = var.activeport4
    port4_mask      = var.activeport4mask
    port4_name      = azurerm_network_interface.ni-activeport4.name
    port4_gw        = var.port4gateway
    passive_peerip  = var.passiveport1
    tenant          = var.tenant_id
    subscription    = var.subscription_id
    clientid        = var.client_id
    clientsecret    = var.client_secret
    adminsport      = var.adminsport
    rsg             = azurerm_resource_group.myterraformgroup.name
    vnetspokea      = azurerm_virtual_network.vnet-spokea.name
    vnetspokeb      = azurerm_virtual_network.vnet-spokeb.name
    vnetspokec      = azurerm_virtual_network.vnet-spokec.name
    
    rs-ip1          = var.spokec-rs-ip1
    rs-ip2          = var.spokec-rs-ip2
    bgp-asn         = var.fgt-bgp-asn

    cluster-public-ip     = azurerm_public_ip.cluster-public-ip.name
    cluster-advpn-ip      = azurerm_public_ip.cluster-advpn-ip.name
    routeprivate_name     = azurerm_route_table.rt-private.name
    routeprivate_route_0  = "default"
    routespoke_name       = azurerm_route_table.vnet-rt-spoke.name
    routespoke_route_0    = "default"
    //routespoke_route_1    = "vnet-spoke-to-spoke"
    //routespoke_route_2    = "vnet-spoke-to-advpn"

    spokes-onprem-cidr        = var.spokes-onprem-cidr
    site-azure-cidr           = var.site-azure-cidr

    spokes-onprem-cidr_net    = split("/",var.spokes-onprem-cidr)[0]
    spokes-onprem-cidr_mask   = split("/",var.spokes-onprem-cidr)[1]
    site-azure-cidr_net       = split("/",var.site-azure-cidr)[0]
    site-azure-cidr_mask      = split("/",var.site-azure-cidr)[1]
    advpn-ipsec-psk           = random_string.advpn-ipsec-psk.result
  }
}
