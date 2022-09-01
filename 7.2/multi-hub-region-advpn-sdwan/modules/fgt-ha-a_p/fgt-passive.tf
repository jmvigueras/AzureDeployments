resource "azurerm_virtual_machine" "regiona-fgt-passive" {
  name                         = "${var.prefix}-${var.zone-id}-fgt-passive"
  location                     = var.location
  resource_group_name          = var.resourcegroup_name
  network_interface_ids        = var.fgt-passive-ni_ids
  primary_network_interface_id = var.fgt-passive-ni_ids[0]
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
    name              = "${var.prefix}-${var.zone-id}-osDisk-fgt-passive"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "${var.prefix}-${var.zone-id}-datadisk-fgt-passive"
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
    storage_uri = var.storage-account_endpoint
  }

  tags = {
    environment = var.tag_env
  }
}

data "template_file" "passiveFortiGate" {
  template = file(var.bootstrap-passive)
  vars = {
    type            = var.license_type
    license_file    = var.license-passive
    port1_ip        = cidrhost(var.subnets-vnet-fgt_nets["mgmt"],11)
    port1_mask      = cidrnetmask(var.subnets-vnet-fgt_nets["mgmt"])
    port1_gw        = cidrhost(var.subnets-vnet-fgt_nets["mgmt"],1)
    port2_ip        = cidrhost(var.subnets-vnet-fgt_nets["public"],11)
    port2_mask      = cidrnetmask(var.subnets-vnet-fgt_nets["public"])
    port2_gw        = cidrhost(var.subnets-vnet-fgt_nets["public"],1)
    port2_name      = var.fgt-passive-ni_names[1]
    port3_ip        = cidrhost(var.subnets-vnet-fgt_nets["private"],11)
    port3_mask      = cidrnetmask(var.subnets-vnet-fgt_nets["private"])
    port3_gw        = cidrhost(var.subnets-vnet-fgt_nets["private"],1)
    port4_ip        = cidrhost(var.subnets-vnet-fgt_nets["advpn"],11)
    port4_mask      = cidrnetmask(var.subnets-vnet-fgt_nets["advpn"])
    port4_gw        = cidrhost(var.subnets-vnet-fgt_nets["advpn"],1)

    active_peerip  = cidrhost(var.subnets-vnet-fgt_nets["mgmt"],10)
    tenant          = var.tenant_id
    subscription    = var.subscription_id
    clientid        = var.client_id
    clientsecret    = var.client_secret
    adminsport      = var.adminsport
    rsg             = var.resourcegroup_name
    zone-id         = var.zone-id

    vnet-spoke-1_name    = var.vnets-spoke-peer["1_name"]
    vnet-spoke-1_net     = var.vnets-spoke-peer["1_net"]
    vnet-spoke-2_name    = var.vnets-spoke-peer["2_name"]
    vnet-spoke-2_net     = var.vnets-spoke-peer["2_net"]

    rs-ip1          = cidrhost(var.subnets-spoke-peer["rs_net"],4)
    rs-ip2          = cidrhost(var.subnets-spoke-peer["rs_net"],5)
    hub-bgp-asn     = var.fgt-bgp-asn
    sites-bgp-asn   = var.sites-bgp-asn

    cluster-public-ip         = var.cluster-public-ip_name
    rt-private_name           = var.rt-private_name
    rt-private_route_0        = "default"
    rt-spoke_name             = var.rt-spoke_name
    rt-spoke_route_0          = "default"

    spokes-onprem-cidr        = var.spokes-onprem-cidr
    site-azure-cidr           = var.site-azure-cidr

    spokes-onprem-cidr_net    = split("/",var.spokes-onprem-cidr)[0]
    spokes-onprem-cidr_mask   = split("/",var.spokes-onprem-cidr)[1]
    site-azure-cidr_net       = split("/",var.site-azure-cidr)[0]
    site-azure-cidr_mask      = split("/",var.site-azure-cidr)[1]
    advpn-ipsec-psk           = var.advpn-ipsec-psk
  }
}
