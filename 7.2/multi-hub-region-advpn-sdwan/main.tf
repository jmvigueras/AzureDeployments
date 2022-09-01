resource "azurerm_resource_group" "rg-regiona" {
  name     = "${var.prefix}-rg-regiona"
  location = var.regiona

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_resource_group" "rg-regionb" {
  name     = "${var.prefix}-rg-regionb"
  location = var.regionb

  tags = {
    environment = var.tag_env
  }
}


// Create NSG for region A
module "nsg-regiona" {
    source = "./modules/nsg"

    prefix              = var.prefix
    location            = var.regiona
    zone-id             = "zA"
    resourcegroup_name  = azurerm_resource_group.rg-regiona.name

    admins-port    = var.adminsport
    admins-cidr    = var.adminscidr
    hamgmt-cidr    = var.site-azure-cidr

    spoke-vnet-cidr     = var.site-azure-cidr
    spoke-site-cidr     = var.spokes-onprem-cidr
}

// Create NSG for region B
module "nsg-regionb" {
    source = "./modules/nsg"

    prefix              = var.prefix
    location            = var.regionb
    zone-id             = "zB"
    resourcegroup_name  = azurerm_resource_group.rg-regionb.name

    admins-port   = var.adminsport
    admins-cidr   = var.adminscidr
    hamgmt-cidr   = var.site-azure-cidr

    spoke-vnet-cidr     = var.site-azure-cidr
    spoke-site-cidr     = var.spokes-onprem-cidr
}
 
// Create VNETS (FGT and spokes) and interfaces for FGT cluster for region A
module "vnet-fgt-regiona" {
    source = "./modules/vnet-fgt"

    prefix                = var.prefix
    location              = var.regiona
    zone-id               = "zA"
    resourcegroup_name    = azurerm_resource_group.rg-regiona.name
    
    vnet-fgt-cidr       = var.vnet-fgt-cidr-regiona
    vnet-spoke-1-cidr   = var.vnet-spokea-cidr-regiona
    vnet-spoke-2-cidr   = var.vnet-spokeb-cidr-regiona
}

// Create VNETS (FGT and spokes) and interfaces for FGT cluster for region B
module "vnet-fgt-regionb" {
    source = "./modules/vnet-fgt"

    prefix                = var.prefix
    location              = var.regionb
    zone-id               = "zB"
    resourcegroup_name    = azurerm_resource_group.rg-regionb.name
    
    vnet-fgt-cidr       = var.vnet-fgt-cidr-regionb
    vnet-spoke-1-cidr   = var.vnet-spokec-cidr-regionb
    vnet-spoke-2-cidr   = var.vnet-spoked-cidr-regionb
}

// Create VNETS (FGT and spoke) and interfaces for FGT site for region A
module "vnet-site-regiona" {
    source = "./modules/vnet-site"

    prefix          = var.prefix
    location        = var.regiona
    zone-id         = "zA"
    site-id         = "1"

    resourcegroup_name    = azurerm_resource_group.rg-regiona.name

    vnet-fgt-site-cidr   = cidrsubnet(var.spokes-onprem-cidr,5,0)
    vnet-spoke-site-cidr = cidrsubnet(var.spokes-onprem-cidr,7,5)
}

// Create FGT cluster in region A
module "fgt-ha-regiona" {
    source = "./modules/fgt-ha-a_p"

    prefix           = var.prefix
    location         = var.regiona
    zone-id          = "zA"

    subscription_id  = var.subscription_id
    client_id        = var.client_id
    client_secret    = var.client_secret
    tenant_id        = var.tenant_id

    resourcegroup_name       = azurerm_resource_group.rg-regiona.name
    storage-account_endpoint = azurerm_storage_account.fgtstorageaccount-regiona.primary_blob_endpoint

    advpn-ipsec-psk       = var.advpn-ipsec-psk
    adminusername         = var.adminusername
    adminpassword         = var.adminpassword
    fgt-bgp-asn           = var.za-fgt-bgp-asn
    
    fgt-active-ni_ids     = [
      module.vnet-fgt-regiona.fgt-active-ni_ids["port1"],
      module.vnet-fgt-regiona.fgt-active-ni_ids["port2"],
      module.vnet-fgt-regiona.fgt-active-ni_ids["port3"],
      module.vnet-fgt-regiona.fgt-active-ni_ids["port4"]
    ]
    fgt-passive-ni_ids    = [
      module.vnet-fgt-regiona.fgt-passive-ni_ids["port1"],
      module.vnet-fgt-regiona.fgt-passive-ni_ids["port2"],
      module.vnet-fgt-regiona.fgt-passive-ni_ids["port3"],
      module.vnet-fgt-regiona.fgt-passive-ni_ids["port4"]
    ]
    fgt-ni-nsg_ids        = [
      module.nsg-regiona.nsg_ids["nsg-mgmt"], 
      module.nsg-regiona.nsg_ids["nsg-public"],
      module.nsg-regiona.nsg_ids["nsg-private"], 
      module.nsg-regiona.nsg_ids["nsg-private"]
    ]  

    fgt-active-ni_names   = module.vnet-fgt-regiona.fgt-active-ni_names
    fgt-passive-ni_names  = module.vnet-fgt-regiona.fgt-passive-ni_names

    cluster-public-ip_name    = module.vnet-fgt-regiona.cluster-public-ip_name
    subnets-vnet-fgt_nets     = module.vnet-fgt-regiona.subnets-vnet-fgt_nets

    rt-private_name       = azurerm_route_table.za-rt-vnet-fgt-private.name
    rt-spoke_name         = azurerm_route_table.za-rt-vnet-spoke.name

    hub-advpn-public-ip    = "10.10.10.254"
    hub-advpn-mpls-ip      = "10.10.20.254"

    hub-peer-ip1      = module.vnet-fgt-regionb.fgt-active-ni_ips["port4"]
    hub-peer-ip2      = module.vnet-fgt-regionb.fgt-passive-ni_ips["port4"]
    hub-peer-bgp-asn  = var.zb-fgt-bgp-asn

    vnets-spoke-peer = {
      "1_name" = module.vnet-fgt-regiona.vnet-fgt-spoke["1_name"]
      "1_net"  = module.vnet-fgt-regiona.vnet-fgt-spoke["1_net"]
      "2_name" = module.vnet-fgt-regiona.vnet-fgt-spoke["2_name"]
      "2_net"  = module.vnet-fgt-regiona.vnet-fgt-spoke["2_net"]
    }

    subnets-spoke-peer = {
      "rs_net" = module.vnet-fgt-regiona.subnets-spoke_nets["spoke1-rs"]
    }
}

// Create FGT cluster in region B
module "fgt-ha-regionb" {
    source = "./modules/fgt-ha-a_p"

    prefix           = var.prefix
    location         = var.regionb
    zone-id          = "zB"

    subscription_id  = var.subscription_id
    client_id        = var.client_id
    client_secret    = var.client_secret
    tenant_id        = var.tenant_id

    resourcegroup_name       = azurerm_resource_group.rg-regionb.name
    storage-account_endpoint = azurerm_storage_account.fgtstorageaccount-regionb.primary_blob_endpoint

    advpn-ipsec-psk       = var.advpn-ipsec-psk
    adminusername         = var.adminusername
    adminpassword         = var.adminpassword
    fgt-bgp-asn           = var.zb-fgt-bgp-asn
    
    fgt-active-ni_ids     = [
      module.vnet-fgt-regionb.fgt-active-ni_ids["port1"],
      module.vnet-fgt-regionb.fgt-active-ni_ids["port2"],
      module.vnet-fgt-regionb.fgt-active-ni_ids["port3"],
      module.vnet-fgt-regionb.fgt-active-ni_ids["port4"]
      ]
    fgt-passive-ni_ids    = [
      module.vnet-fgt-regionb.fgt-passive-ni_ids["port1"],
      module.vnet-fgt-regionb.fgt-passive-ni_ids["port2"],
      module.vnet-fgt-regionb.fgt-passive-ni_ids["port3"],
      module.vnet-fgt-regionb.fgt-passive-ni_ids["port4"]
      ]
    fgt-ni-nsg_ids        = [
      module.nsg-regionb.nsg_ids["nsg-mgmt"], 
      module.nsg-regionb.nsg_ids["nsg-public"],
      module.nsg-regionb.nsg_ids["nsg-private"], 
      module.nsg-regionb.nsg_ids["nsg-private"]
      ]  
    
    fgt-active-ni_names   = module.vnet-fgt-regionb.fgt-active-ni_names
    fgt-passive-ni_names  = module.vnet-fgt-regionb.fgt-passive-ni_names
    
    cluster-public-ip_name    = module.vnet-fgt-regionb.cluster-public-ip_name
    subnets-vnet-fgt_nets     = module.vnet-fgt-regionb.subnets-vnet-fgt_nets

    rt-private_name       = azurerm_route_table.za-rt-vnet-fgt-private.name
    rt-spoke_name         = azurerm_route_table.za-rt-vnet-spoke.name

    hub-advpn-public-ip    = "10.10.10.253"
    hub-advpn-mpls-ip      = "10.10.20.253"

    hub-peer-ip1      = module.vnet-fgt-regiona.fgt-active-ni_ips["port4"]
    hub-peer-ip2      = module.vnet-fgt-regiona.fgt-passive-ni_ips["port4"]
    hub-peer-bgp-asn  = var.za-fgt-bgp-asn

    vnets-spoke-peer = {
      "1_name" = module.vnet-fgt-regionb.vnet-fgt-spoke["1_name"]
      "1_net"  = module.vnet-fgt-regionb.vnet-fgt-spoke["1_net"]
      "2_name" = module.vnet-fgt-regionb.vnet-fgt-spoke["2_name"]
      "2_net"  = module.vnet-fgt-regionb.vnet-fgt-spoke["2_net"]
    }

    subnets-spoke-peer = {
      "rs_net" = module.vnet-fgt-regionb.subnets-spoke_nets["spoke1-rs"]
    }
}    

// Create FGT single site in region A
module "fgt-single-site1" {
    source = "./modules/fgt-single-site"

    prefix           = var.prefix
    location         = var.regiona
    zone-id          = "zA"
    site-id         = "1"

    resourcegroup_name       = azurerm_resource_group.rg-regiona.name
    storage-account_endpoint = azurerm_storage_account.fgtstorageaccount-regiona.primary_blob_endpoint

    za-fgt-bgp-asn  = var.za-fgt-bgp-asn
    zb-fgt-bgp-asn  = var.zb-fgt-bgp-asn

    advpn-ipsec-psk       = var.advpn-ipsec-psk
    adminusername         = var.adminusername
    adminpassword         = var.adminpassword

    fgt-ni_ids        = [
      module.vnet-site-regiona.fgt-site-ni_ids["port1"],
      module.vnet-site-regiona.fgt-site-ni_ids["port2"], 
      module.vnet-site-regiona.fgt-site-ni_ids["port3"]
      ]
    fgt-ni-nsg_ids    = [
      module.nsg-regiona.nsg_ids["nsg-mgmt"], 
      module.nsg-regiona.nsg_ids["nsg-public"],
      module.nsg-regiona.nsg_ids["nsg-private"]
      ]     
    hub-advpn-ips = {
      huba-advpn-public-ip  = module.vnet-fgt-regiona.cluster-public-ip_ip
      hubb-advpn-public-ip  = module.vnet-fgt-regionb.cluster-public-ip_ip
      huba-advpn-mpls-ip_1  = module.vnet-fgt-regiona.fgt-active-ni_ips["port4"]
      huba-advpn-mpls-ip_2  = module.vnet-fgt-regiona.fgt-passive-ni_ips["port4"]
      huba-mpls-local-1     = "10.10.10.1"
      huba-mpls-local-2     = "10.10.10.2"
      huba-mpls-remote      = "10.10.10.254"
      huba-public-local     = "10.10.20.1"
      huba-public-remote    = "10.10.20.254"
      hubb-public-local     = "10.10.20.2"
      hubb-public-remote    = "10.10.20.253"
    }
    healthcheck-srv =  {
      healthcheck-za-srv  = azurerm_network_interface.za-ni-vm-spoke-1.private_ip_address
      healthcheck-zb-srv  = azurerm_network_interface.zb-ni-vm-spoke-1.private_ip_address
    }

    subnets-site-peer     = module.vnet-site-regiona.subnets-site-peer
    subnets-vnet-fgt_nets = module.vnet-site-regiona.subnets-vnet-fgt_nets
}

// Create peering between FGT VNETs Region A and Region B

resource "azurerm_virtual_network_peering" "peer-za-to-zb-1" {
  name                      = "${var.prefix}-peer-za-to-zb-1"
  resource_group_name       = azurerm_resource_group.rg-regiona.name
  virtual_network_name      = module.vnet-fgt-regiona.vnet-fgt_name
  remote_virtual_network_id = module.vnet-fgt-regionb.vnet-fgt_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peer-za-to-zb-2" {
  name                      = "${var.prefix}-peer-za-to-zb-2"
  resource_group_name       = azurerm_resource_group.rg-regionb.name
  virtual_network_name      = module.vnet-fgt-regionb.vnet-fgt_name
  remote_virtual_network_id = module.vnet-fgt-regiona.vnet-fgt_id
  allow_forwarded_traffic   = true
}
