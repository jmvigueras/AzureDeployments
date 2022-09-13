// Public IP for VGW Zone A FGT
resource "azurerm_public_ip" "za-vgw-vnet-fgt-public-ip" {
  name                = "${var.prefix}-za-vgw-public-ip"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tag_env
  }
}

//Create VGW in vnet FGT Zone A
resource "azurerm_virtual_network_gateway" "za-vgw-vnet-fgt" {
  name                  = "${var.prefix}-za-vgw-vnet-fgt"
  location              = var.regiona
  resource_group_name   = azurerm_resource_group.rg-regiona.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.za-vgw-vnet-fgt-public-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet-fgt-regiona.subnets-vnet-fgt_ids["vgw"]
  }

  bgp_settings {
    asn = 65515
  }
}

/* (Used for simulated MPLS/Expressroute to RegionB from Site)

// Public IP for VGW Zone B FGT
resource "azurerm_public_ip" "zb-vgw-vnet-fgt-public-ip" {
  name                = "${var.prefix}-zb-vgw-public-ip"
  location            = var.regionb
  resource_group_name = azurerm_resource_group.rg-regionb.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tag_env
  }
}

//Create VGW in vnet FGT Zone B
resource "azurerm_virtual_network_gateway" "zb-vgw-vnet-fgt" {
  name                  = "${var.prefix}-zb-vgw-vnet-fgt"
  location              = var.regionb
  resource_group_name   = azurerm_resource_group.rg-regionb.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.zb-vgw-vnet-fgt-public-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet-fgt-regionb.subnets-vnet-fgt_ids["vgw"]
  }

  bgp_settings {
    asn = 65516
  }
}
*/

// Public IP for VGW Zone A Site 1
resource "azurerm_public_ip" "za-vgw-vnet-site-public-ip" {
  name                = "${var.prefix}-za-vgw-site-public-ip"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tag_env
  }
}

//Create VGW in vnet FGT Zone A Site 1
resource "azurerm_virtual_network_gateway" "za-vgw-vnet-site" {
  name                  = "${var.prefix}-za-vgw-vnet-site"
  location              = var.regiona
  resource_group_name   = azurerm_resource_group.rg-regiona.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.za-vgw-vnet-site-public-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet-site-regiona.subnets-vnet-fgt_ids["vgw"]
  }

  bgp_settings {
    asn = 65010
  }
}

// Connection defintion VNET Site1 to VNET FGT Zone A 
resource "azurerm_virtual_network_gateway_connection" "za-cx-vnet-site-vnet-fgt-1" {
    name                  = "${var.prefix}-za-cx-vnet-site-vnet-fgt-1"
    location              = var.regiona
    resource_group_name   = azurerm_resource_group.rg-regiona.name

    enable_bgp                      = true
    type                            = "Vnet2Vnet"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.za-vgw-vnet-fgt.id
    peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.za-vgw-vnet-site.id

    shared_key = var.s2s-ipsec-psk
}

resource "azurerm_virtual_network_gateway_connection" "za-cx-vnet-site-vnet-fgt-2" {
    name                  = "${var.prefix}-za-cx-vnet-site-vnet-fgt-2"
    location              = var.regiona
    resource_group_name   = azurerm_resource_group.rg-regiona.name

    enable_bgp                      = true
    type                            = "Vnet2Vnet"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.za-vgw-vnet-site.id
    peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.za-vgw-vnet-fgt.id 

    shared_key = var.s2s-ipsec-psk
}

/* (Used for simulated MPLS/Expressroute to RegionB from Site)

// Connection defintion VNET Site1 to VNET FGT Zone B
resource "azurerm_virtual_network_gateway_connection" "zb-cx-vnet-site-vnet-fgt-1" {
    name                  = "${var.prefix}-zb-cx-vnet-site-vnet-fgt-1"
    location              = var.regionb
    resource_group_name   = azurerm_resource_group.rg-regionb.name

    enable_bgp                      = true
    type                            = "Vnet2Vnet"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.zb-vgw-vnet-fgt.id
    peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.za-vgw-vnet-site.id

    shared_key = var.s2s-ipsec-psk
}

resource "azurerm_virtual_network_gateway_connection" "zb-cx-vnet-site-vnet-fgt-2" {
    name                  = "${var.prefix}-zb-cx-vnet-site-vnet-fgt-2"
    location              = var.regiona
    resource_group_name   = azurerm_resource_group.rg-regiona.name

    enable_bgp                      = true
    type                            = "Vnet2Vnet"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.za-vgw-vnet-site.id
    peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.zb-vgw-vnet-fgt.id 

    shared_key = var.s2s-ipsec-psk
}

*/
