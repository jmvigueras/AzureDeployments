resource "azurerm_public_ip" "za-public-ip-rs-spoke-1" {
  name                = "${var.prefix}-za-rs-spoke-1-pip"
  resource_group_name = azurerm_resource_group.rg-regiona.name
  location            = var.regiona
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_route_server" "za-rs-spoke-1" {
  name                             = "${var.prefix}-za-rs-spoke-1"
  resource_group_name              = azurerm_resource_group.rg-regiona.name
  location                         = var.regiona
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.za-public-ip-rs-spoke-1.id
  subnet_id                        = module.vnet-fgt-regiona.subnets-spoke_ids["spoke1-rs"]
}

resource "azurerm_route_server_bgp_connection" "za-rs-spoke-1-bgp-fgt-active" {
  name            = "${var.prefix}-za-bgp-fgt-active"
  route_server_id = azurerm_route_server.za-rs-spoke-1.id
  peer_asn        = var.za-fgt-bgp-asn
  peer_ip         = module.vnet-fgt-regiona.fgt-active-ni_ips["port3"]
}

resource "azurerm_route_server_bgp_connection" "rs-spoke-1-bgp-fgt-passive" {
  name            = "${var.prefix}-za-bgp-fgt-passive"
  route_server_id = azurerm_route_server.za-rs-spoke-1.id
  peer_asn        = var.za-fgt-bgp-asn
  peer_ip         = module.vnet-fgt-regiona.fgt-passive-ni_ips["port3"]
}