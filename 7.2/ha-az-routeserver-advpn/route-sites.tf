// Route-table definition

resource "azurerm_route_table" "rt-site1-private" {
  name                = "${var.prefix}-rt-site1-private"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

resource "azurerm_route_table" "rt-site2-private" {
  name                = "${var.prefix}-rt-site2-private"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

// Routes definition

resource "azurerm_route" "r-default-site1-private" {
  depends_on             = [azurerm_virtual_machine.fgt-site1]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-site1-private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.ni-site1-port3.private_ip_address
}

resource "azurerm_route" "r-default-site2-private" {
  depends_on             = [azurerm_virtual_machine.fgt-site2]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-site2-private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.ni-site2-port3.private_ip_address
}

// Routes association

resource "azurerm_subnet_route_table_association" "ra-site1-private" {
  depends_on     = [azurerm_route_table.rt-site1-private]
  subnet_id      = azurerm_subnet.subnet-internal-site1.id
  route_table_id = azurerm_route_table.rt-site1-private.id
}

resource "azurerm_subnet_route_table_association" "ra-site2-private" {
  depends_on     = [azurerm_route_table.rt-site2-private]
  subnet_id      = azurerm_subnet.subnet-internal-site2.id
  route_table_id = azurerm_route_table.rt-site2-private.id
}
