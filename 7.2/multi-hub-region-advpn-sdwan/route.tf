// Table routes Region A - FGT 

// Route-table definition
resource "azurerm_route_table" "za-rt-vnet-fgt-private" {
  name                = "${var.prefix}-za-rt-vnet-fgt-private"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name

  disable_bgp_route_propagation = true
}

resource "azurerm_route_table" "za-rt-vnet-spoke" {
  name                = "${var.prefix}-za-rt-vnet-spoke"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name

  disable_bgp_route_propagation = true
}

// Routes definition 
resource "azurerm_route" "za-r-default-private" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.rg-regiona.name
  route_table_name       = azurerm_route_table.za-rt-vnet-fgt-private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.vnet-fgt-regiona.fgt-active-ni_ips["port2"]
}

resource "azurerm_route" "za-r-default-vnet-spokes" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.rg-regiona.name
  route_table_name       = azurerm_route_table.za-rt-vnet-spoke.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.vnet-fgt-regiona.fgt-active-ni_ips["port3"]
}

// Route table association
resource "azurerm_subnet_route_table_association" "za-privateassociate" {
  subnet_id      = module.vnet-fgt-regiona.subnets-vnet-fgt_ids["private"]
  route_table_id = azurerm_route_table.za-rt-vnet-fgt-private.id
}

resource "azurerm_subnet_route_table_association" "za-spoke1associate" {
  subnet_id      = module.vnet-fgt-regiona.subnets-spoke_ids["spoke1-vm"]
  route_table_id = azurerm_route_table.za-rt-vnet-spoke.id
}

resource "azurerm_subnet_route_table_association" "za-spoke2associate" {
  subnet_id      = module.vnet-fgt-regiona.subnets-spoke_ids["spoke2-vm"]
  route_table_id = azurerm_route_table.za-rt-vnet-spoke.id
}

// Table routes Region B - FGT 

// Route-table definition
resource "azurerm_route_table" "zb-rt-vnet-fgt-private" {
  name                = "${var.prefix}-zb-rt-vnet-fgt-private"
  location            = var.regionb
  resource_group_name = azurerm_resource_group.rg-regionb.name

  disable_bgp_route_propagation = true
}

resource "azurerm_route_table" "zb-rt-vnet-spoke" {
  name                = "${var.prefix}-zb-rt-vnet-spoke"
  location            = var.regionb
  resource_group_name = azurerm_resource_group.rg-regionb.name

  disable_bgp_route_propagation = true
}

// Routes definition 
resource "azurerm_route" "zb-r-default-private" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.rg-regionb.name
  route_table_name       = azurerm_route_table.zb-rt-vnet-fgt-private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.vnet-fgt-regionb.fgt-active-ni_ips["port2"]
}

resource "azurerm_route" "zb-r-default-vnet-spokes" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.rg-regionb.name
  route_table_name       = azurerm_route_table.zb-rt-vnet-spoke.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.vnet-fgt-regionb.fgt-active-ni_ips["port3"]
}

// Route table association
resource "azurerm_subnet_route_table_association" "zb-privateassociate" {
  subnet_id      = module.vnet-fgt-regionb.subnets-vnet-fgt_ids["private"]
  route_table_id = azurerm_route_table.zb-rt-vnet-fgt-private.id
}

resource "azurerm_subnet_route_table_association" "zb-spoke1associate" {
  subnet_id      = module.vnet-fgt-regionb.subnets-spoke_ids["spoke1-vm"]
  route_table_id = azurerm_route_table.zb-rt-vnet-spoke.id
}

resource "azurerm_subnet_route_table_association" "zb-spoke2associate" {
  subnet_id      = module.vnet-fgt-regionb.subnets-spoke_ids["spoke2-vm"]
  route_table_id = azurerm_route_table.zb-rt-vnet-spoke.id
}

// Table routes Region A - Site

// Route-table definition
resource "azurerm_route_table" "za-rt-vnet-site-private" {
  name                = "${var.prefix}-za-rt-vnet-site-private"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name

  disable_bgp_route_propagation = true
}

resource "azurerm_route_table" "za-rt-vnet-site-spoke" {
  name                = "${var.prefix}-za-rt-vnet-site-spoke"
  location            = var.regiona
  resource_group_name = azurerm_resource_group.rg-regiona.name

  disable_bgp_route_propagation = true
}

// Routes definition 
resource "azurerm_route" "za-r-site-default-private" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.rg-regiona.name
  route_table_name       = azurerm_route_table.za-rt-vnet-site-private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.vnet-site-regiona.fgt-site-ni_ips["port2"]
}

resource "azurerm_route" "za-r-site-default-vnet-spokes" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.rg-regiona.name
  route_table_name       = azurerm_route_table.za-rt-vnet-site-spoke.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.vnet-site-regiona.fgt-site-ni_ips["port3"]
}

// Route table association
resource "azurerm_subnet_route_table_association" "za-site-privateassociate" {
  subnet_id      = module.vnet-site-regiona.subnets-vnet-fgt_ids["private"]
  route_table_id = azurerm_route_table.za-rt-vnet-site-private.id
}

resource "azurerm_subnet_route_table_association" "za-site-spoke1associate" {
  subnet_id      = module.vnet-site-regiona.subnets-site-peer["1_id"]
  route_table_id = azurerm_route_table.za-rt-vnet-site-spoke.id
}