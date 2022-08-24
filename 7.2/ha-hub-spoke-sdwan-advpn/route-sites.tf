// Route-table definition

resource "azurerm_route_table" "rt-site1-private" {
  name                = "${var.prefix}-rt-site1-private"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  disable_bgp_route_propagation = true
}

resource "azurerm_route_table" "rt-spoke-site1" {
  name                = "${var.prefix}-rt-spoke-site1"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  disable_bgp_route_propagation = true
}

resource "azurerm_route_table" "rt-site2-private" {
  name                = "${var.prefix}-rt-site2-private"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  
  disable_bgp_route_propagation = true
}

resource "azurerm_route_table" "rt-spoke-site2" {
  name                = "${var.prefix}-rt-spoke-site2"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  disable_bgp_route_propagation = true
}

// Routes definition

resource "azurerm_route" "r-default-site1-private" {
  depends_on             = [azurerm_virtual_machine.fgt-site1]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-site1-private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.ni-site1-port2.private_ip_address
}

resource "azurerm_route" "r-default-site2-private" {
  depends_on             = [azurerm_virtual_machine.fgt-site2]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-site2-private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.ni-site2-port2.private_ip_address
}

resource "azurerm_route" "r-default-spoke-site1" {
  depends_on             = [azurerm_virtual_machine.fgt-site1]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-spoke-site1.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.ni-site1-port3.private_ip_address
}

resource "azurerm_route" "r-default-spoke-site2" {
  depends_on             = [azurerm_virtual_machine.fgt-site2]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-spoke-site2.name
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

resource "azurerm_subnet_route_table_association" "ra-site1-spoke" {
  depends_on     = [azurerm_route_table.rt-spoke-site1]
  subnet_id      = azurerm_subnet.subnet-spoke-site1.id
  route_table_id = azurerm_route_table.rt-spoke-site1.id
}

resource "azurerm_subnet_route_table_association" "ra-site2-spoke" {
  depends_on     = [azurerm_route_table.rt-spoke-site2]
  subnet_id      = azurerm_subnet.subnet-spoke-site2.id
  route_table_id = azurerm_route_table.rt-spoke-site2.id
}