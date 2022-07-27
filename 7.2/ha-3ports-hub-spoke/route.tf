resource "azurerm_route_table" "internal" {
  name                = "InternalRouteTable1"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

resource "azurerm_route" "default" {
  depends_on             = [azurerm_virtual_machine.passivefgtvm]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.internal.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.activeport2
}

resource "azurerm_subnet_route_table_association" "internalassociate" {
  depends_on     = [azurerm_route_table.internal]
  subnet_id      = azurerm_subnet.privatesubnet.id
  route_table_id = azurerm_route_table.internal.id
}

resource "azurerm_route_table" "routetablespoke" {
  name                = "RouteTableSpokeVNETs"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

resource "azurerm_route" "defaultspokes" {
  depends_on             = [azurerm_virtual_machine.passivefgtvm]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.routetablespoke.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.activeport3
}

resource "azurerm_subnet_route_table_association" "spokeaassociate" {
  depends_on     = [azurerm_route_table.routetablespoke]
  subnet_id      = azurerm_subnet.spokeasubnet.id
  route_table_id = azurerm_route_table.routetablespoke.id
}

resource "azurerm_subnet_route_table_association" "spokebassociate" {
  depends_on     = [azurerm_route_table.routetablespoke]
  subnet_id      = azurerm_subnet.spokebsubnet.id
  route_table_id = azurerm_route_table.routetablespoke.id
}