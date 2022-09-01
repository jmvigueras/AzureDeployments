// Create Fortgate VM site1

resource "azurerm_virtual_machine" "fgt-site1" {
  name                         = "${var.prefix}-${var.zone-id}-fgt-site${var.site-id}"
  location                     = var.location
  resource_group_name          = var.resourcegroup_name
  network_interface_ids        = var.fgt-ni_ids
  primary_network_interface_id = var.fgt-ni_ids[0]
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
    name              = "${var.prefix}-${var.zone-id}-osDisk-fgt-site1"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-${var.zone-id}-datadisk-fgt-site1"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgt-site1"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.siteFortiGate.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.storage-account_endpoint
  }

  tags = {
    environment = var.tag_env
  }
}

data "template_file" "siteFortiGate" {
  template = file(var.bootstrap-site)
  vars = {
    type            = var.license_type
    license_file    = var.license
    port1_ip        = cidrhost(var.subnets-vnet-fgt_nets["mgmt"],10)
    port1_mask      = cidrnetmask(var.subnets-vnet-fgt_nets["mgmt"])
    port1_gw        = cidrhost(var.subnets-vnet-fgt_nets["mgmt"],1)
    port2_ip        = cidrhost(var.subnets-vnet-fgt_nets["public"],10)
    port2_mask      = cidrnetmask(var.subnets-vnet-fgt_nets["public"])
    port2_gw        = cidrhost(var.subnets-vnet-fgt_nets["public"],1)
    port3_ip        = cidrhost(var.subnets-vnet-fgt_nets["private"],10)
    port3_mask      = cidrnetmask(var.subnets-vnet-fgt_nets["private"])
    port3_gw        = cidrhost(var.subnets-vnet-fgt_nets["private"],1)

    site-id         = var.site-id
    adminsport      = var.adminsport
    huba-bgp-asn    = var.za-fgt-bgp-asn
    hubb-bgp-asn    = var.zb-fgt-bgp-asn
    site-bgp-asn    = var.sites-bgp-asn

    spokes-onprem-cidr      = var.spokes-onprem-cidr
    spoke-local-cidr        = var.subnets-site-peer["1_net"]
    site-azure-cidr         = var.site-azure-cidr
    advpn-ipsec-psk         = var.advpn-ipsec-psk

    huba-public-local       = var.hub-advpn-ips["huba-public-local"]
    huba-public-remote      = var.hub-advpn-ips["huba-public-remote"]
    hubb-public-local       = var.hub-advpn-ips["hubb-public-local"]
    hubb-public-remote      = var.hub-advpn-ips["hubb-public-remote"]
    huba-mpls-local-1       = var.hub-advpn-ips["huba-mpls-local-1"]
    huba-mpls-local-2       = var.hub-advpn-ips["huba-mpls-local-2"]
    huba-mpls-remote        = var.hub-advpn-ips["huba-mpls-remote"]
    huba-advpn-public-ip    = var.hub-advpn-ips["huba-advpn-public-ip"]
    hubb-advpn-public-ip    = var.hub-advpn-ips["hubb-advpn-public-ip"]
    huba-advpn-mpls-ip_1    = var.hub-advpn-ips["huba-advpn-mpls-ip_1"]
    huba-advpn-mpls-ip_2    = var.hub-advpn-ips["huba-advpn-mpls-ip_2"]

    healthcheck-za-srv      = var.healthcheck-srv["healthcheck-za-srv"]
    healthcheck-zb-srv      = var.healthcheck-srv["healthcheck-zb-srv"]
  }
}


