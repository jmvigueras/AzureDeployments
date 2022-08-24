// Create virtual network gateways

resource "azurerm_virtual_network_gateway" "vgw-vnet-fgt" {
  name                = "${var.prefix}-vgw-vnet-fgt"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vgw-public-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-vgw.id
  }

  bgp_settings {
    asn = 65515
  }
}

resource "azurerm_virtual_network_gateway" "vgw-vnet-site1" {
  name                = "${var.prefix}-vgw-vnet-site1"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.site1-vgw-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-GatewaySubnet-site1.id
  }

  bgp_settings {
    asn = 65001
  }
}

resource "azurerm_virtual_network_gateway" "vgw-vnet-site2" {
  name                = "${var.prefix}-vgw-vnet-site2"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.site2-vgw-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-GatewaySubnet-site2.id
  }

  bgp_settings {
    asn = 65001
  }
}


// Connection defintion

resource "azurerm_virtual_network_gateway_connection" "s2s_fgt_site1-1" {
    depends_on          = [azurerm_virtual_network_gateway.vgw-vnet-fgt,azurerm_virtual_network_gateway.vgw-vnet-site1]
    name                = "${var.prefix}-s2s_fgt_site1-1"
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    enable_bgp                      = true
    type                            = "Vnet2Vnet"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.vgw-vnet-fgt.id
    peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw-vnet-site1.id

    shared_key = var.s2s-ipsec-psk
}

resource "azurerm_virtual_network_gateway_connection" "s2s_fgt_site1-2" {
    depends_on          = [azurerm_virtual_network_gateway.vgw-vnet-fgt,azurerm_virtual_network_gateway.vgw-vnet-site1]
    name                = "${var.prefix}-s2s_fgt_site1-2"
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    enable_bgp                      = true
    type                            = "Vnet2Vnet"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.vgw-vnet-site1.id
    peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw-vnet-fgt.id

    shared_key = var.s2s-ipsec-psk
}

resource "azurerm_virtual_network_gateway_connection" "s2s_fgt_site2-1" {
    depends_on          = [azurerm_virtual_network_gateway.vgw-vnet-fgt,azurerm_virtual_network_gateway.vgw-vnet-site2]
    name                = "${var.prefix}-s2s_fgt_site2-1"
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    enable_bgp                      = true
    type                            = "Vnet2Vnet"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.vgw-vnet-fgt.id
    peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw-vnet-site2.id

    shared_key = var.s2s-ipsec-psk
}

resource "azurerm_virtual_network_gateway_connection" "s2s_fgt_site2-2" {
    depends_on          = [azurerm_virtual_network_gateway.vgw-vnet-fgt,azurerm_virtual_network_gateway.vgw-vnet-site1]
    name                = "${var.prefix}-s2s_fgt_site2-2"
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    enable_bgp                      = true
    type                            = "Vnet2Vnet"
    virtual_network_gateway_id      = azurerm_virtual_network_gateway.vgw-vnet-site2.id
    peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw-vnet-fgt.id

    shared_key = var.s2s-ipsec-psk
}
  