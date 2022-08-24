// Create Fortgate VM site2

resource "azurerm_virtual_machine" "fgt-site2" {
  name                         = "${var.prefix}-fgt-site2"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.ni-site2-port1.id, azurerm_network_interface.ni-site2-port2.id, azurerm_network_interface.ni-site2-port3.id]
  primary_network_interface_id = azurerm_network_interface.ni-site2-port1.id
  vm_size                      = var.size

  lifecycle {
    ignore_changes = [os_profile]
  }
  
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
    name              = "${var.prefix}-osDisk-fgt-site2"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-datadisk-fgt-site2"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgt-site2"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.site2FortiGate.rendered
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

data "template_file" "site2FortiGate" {
  template = file(var.bootstrap-site)
  vars = {
    type            = var.license_type
    license_file    = var.license
    port1_ip        = azurerm_network_interface.ni-site2-port1.private_ip_address
    port1_mask      = cidrnetmask(azurerm_subnet.subnet-mgmt-site2.address_prefixes[0])
    port1_gw        = cidrhost(azurerm_subnet.subnet-mgmt-site2.address_prefixes[0],1)
    port2_ip        = azurerm_network_interface.ni-site2-port2.private_ip_address
    port2_mask      = cidrnetmask(azurerm_subnet.subnet-public-site2.address_prefixes[0])
    port2_gw        = cidrhost(azurerm_subnet.subnet-public-site2.address_prefixes[0],1)
    port3_ip        = azurerm_network_interface.ni-site2-port3.private_ip_address
    port3_mask      = cidrnetmask(azurerm_subnet.subnet-internal-site2.address_prefixes[0])
    port3_net       = azurerm_subnet.subnet-internal-site2.address_prefixes[0]
    port3_gw        = cidrhost(azurerm_subnet.subnet-internal-site2.address_prefixes[0],1)

    site_number     = "2"
    adminsport      = var.adminsport
    hub-bgp-asn     = var.fgt-bgp-asn
    site-bgp-asn    = var.sites-bgp-asn

    vgw-vnet-fgt_net      = azurerm_subnet.subnet-GatewaySubnet-site1.address_prefixes[0]
    spokes-onprem-cidr    = var.spokes-onprem-cidr
    spoke-site-cidr       = azurerm_subnet.subnet-spoke-site2.address_prefixes[0]
    site-azure-cidr       = var.site-azure-cidr
    advpn-ipsec-psk       = var.advpn-ipsec-psk
    hub-advpn-public-ip   = azurerm_public_ip.cluster-public-ip.ip_address
    hub-advpn-mpls-ip_1   = var.activeport4
    hub-advpn-mpls-ip_2   = var.passiveport4
    hc-azure-srv          = azurerm_network_interface.ni-vm-spokea.private_ip_address

    mpls-to-az-1_ip       = "10.10.20.2"
    mpls-to-az-2_ip       = "10.10.20.4"
  }
}