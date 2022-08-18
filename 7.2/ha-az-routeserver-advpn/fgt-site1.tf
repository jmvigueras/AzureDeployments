// Create Fortgate VM site1

resource "azurerm_virtual_machine" "fgt-site1" {
  name                         = "${var.prefix}-fgt-site1"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.ni-site1-port1.id, azurerm_network_interface.ni-site1-port2.id, azurerm_network_interface.ni-site1-port3.id]
  primary_network_interface_id = azurerm_network_interface.ni-site1-port1.id
  vm_size                      = var.size

  storage_image_reference {
    publisher = var.publisher
    offer     = var.fgtoffer
    sku       = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    version   = var.fgtversion
    id        = null
  }

  plan {
    name      = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    publisher = var.publisher
    product   = var.fgtoffer
  }

  storage_os_disk {
    name              = "${var.prefix}-osDisk-fgt-site1"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-datadisk-fgt-site1"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgt-site1"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.site1FortiGate.rendered
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

data "template_file" "site1FortiGate" {
  template = file(var.bootstrap-site)
  vars = {
    type            = var.license_type
    license_file    = var.license
    port1_ip        = azurerm_network_interface.ni-site1-port1.private_ip_address
    port1_mask      = cidrnetmask(azurerm_subnet.subnet-mgmt-site1.address_prefixes[0])
    port1_gw        = cidrhost(azurerm_subnet.subnet-mgmt-site1.address_prefixes[0],1)
    port2_ip        = azurerm_network_interface.ni-site1-port2.private_ip_address
    port2_mask      = cidrnetmask(azurerm_subnet.subnet-public-site1.address_prefixes[0])
    port2_gw        = cidrhost(azurerm_subnet.subnet-public-site1.address_prefixes[0],1)
    port3_ip        = azurerm_network_interface.ni-site1-port3.private_ip_address
    port3_mask      = cidrnetmask(azurerm_subnet.subnet-internal-site1.address_prefixes[0])
    port3_net       = azurerm_subnet.subnet-internal-site1.address_prefixes[0]

    site_number     = "1"
    adminsport      = var.adminsport

    advpn-ipsec-psk       = random_string.advpn-ipsec-psk.result
    hub-advpn-public-ip   = azurerm_public_ip.cluster-advpn-ip.ip_address
  }
}


