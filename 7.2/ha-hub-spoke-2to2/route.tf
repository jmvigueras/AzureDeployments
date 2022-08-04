// Route-table definition

resource "azurerm_route_table" "rt-private" {
  name                = "${var.prefix}-rt-private"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

resource "azurerm_route_table" "rt-spoke" {
  name                = "${var.prefix}-rt-spoke"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

// Routes definition

resource "azurerm_route" "r-default-private" {
  depends_on             = [azurerm_virtual_machine.fgt-active]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.activeport2
}

resource "azurerm_route" "r-default-spokes" {
  depends_on             = [azurerm_virtual_machine.fgt-active]
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-spoke.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.activeport2
}

resource "azurerm_route" "r-spoke-to-spoke" {
  depends_on             = [azurerm_virtual_machine.fgt-active]
  name                   = "spoke-to-spoke"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-spoke.name
  address_prefix         = "${var.site-azure-cidr}"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.activeport3
}

resource "azurerm_route" "r-spoke-to-onprem" {
  depends_on             = [azurerm_virtual_machine.fgt-active]
  name                   = "spoke-to-onprem"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.rt-spoke.name
  address_prefix         = "${var.site-onprem-cidr}"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.activeport3
}

// Route table association

resource "azurerm_subnet_route_table_association" "privateassociate" {
  depends_on     = [azurerm_route_table.rt-private]
  subnet_id      = azurerm_subnet.subnet-private.id
  route_table_id = azurerm_route_table.rt-private.id
}

resource "azurerm_subnet_route_table_association" "spokeaassociate" {
  depends_on     = [azurerm_route_table.rt-spoke]
  subnet_id      = azurerm_subnet.subnet-spokea.id
  route_table_id = azurerm_route_table.rt-spoke.id
}

resource "azurerm_subnet_route_table_association" "spokebassociate" {
  depends_on     = [azurerm_route_table.rt-spoke]
  subnet_id      = azurerm_subnet.subnet-spokeb.id
  route_table_id = azurerm_route_table.rt-spoke.id
}