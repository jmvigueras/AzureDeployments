resource "azurerm_public_ip" "public-ip-routeserver" {
  name                = "${var.prefix}-rs-spokec-pip"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_route_server" "rs-spokec" {
  depends_on                       = [azurerm_virtual_machine.fgt-active]
  name                             = "${var.prefix}-rs-spokec"
  resource_group_name              = azurerm_resource_group.myterraformgroup.name
  location                         = var.location
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.public-ip-routeserver.id
  subnet_id                        = azurerm_subnet.subnet-spokec-routeserver.id
}

resource "azurerm_route_server_bgp_connection" "rs-spokec-bgp-fgt-active" {
  depends_on      = [azurerm_route_server.rs-spokec]
  name            = "${var.prefix}-bgp-fgt-active"
  route_server_id = azurerm_route_server.rs-spokec.id
  peer_asn        = var.fgt-bgp-asn
  peer_ip         = var.activeport3
}

resource "azurerm_route_server_bgp_connection" "rs-spokec-bgp-fgt-passive" {
  depends_on      = [azurerm_route_server.rs-spokec]
  name            = "${var.prefix}-bgp-fgt-passive"
  route_server_id = azurerm_route_server.rs-spokec.id
  peer_asn        = var.fgt-bgp-asn
  peer_ip         = var.passiveport3
}