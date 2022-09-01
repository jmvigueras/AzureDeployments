//  Network Security Group
resource "azurerm_network_security_group" "nsg-mgmt-ha" {
  name                = "${var.prefix}-${var.zone-id}-nsg-mgmt-ha"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  
  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_security_rule" "nsr-ingress-mgmt-ha-sync" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-sync"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${var.hamgmt-cidr}"
  destination_address_prefix  = "${var.hamgmt-cidr}"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt-ha.name
}

resource "azurerm_network_security_rule" "nsr-ingress-mgmt-ha-ssh" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.admins-cidr}"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt-ha.name
}

resource "azurerm_network_security_rule" "nsr-ingress-mgmt-ha-https" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-https"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "${var.admins-port}"
  source_address_prefix       = "${var.admins-cidr}"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt-ha.name
}

resource "azurerm_network_security_rule" "nsr-egress-mgmt-ha-all" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt-ha.name
}


resource "azurerm_network_security_group" "nsg-public" {
  name                = "${var.prefix}-${var.zone-id}-nsg-public"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  
  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_security_rule" "nsr-ingress-public-tcp" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-tcp"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_rule" "nsr-ingress-public-ipsec-500" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-ipsec-500"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "500"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_rule" "nsr-ingress-public-ipsec-4500" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-ipsec-4500"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "4500"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_rule" "nsr-ingress-public-from-vnet-spoke" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-from-vnet-spoke"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${var.spoke-vnet-cidr}"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_rule" "nsr-ingress-public-from-spoke" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-from-site-spoke"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${var.spoke-site-cidr}"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_rule" "nsr-egress-public-all" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-public.name
}

resource "azurerm_network_security_group" "nsg-private" {
  name                = "${var.prefix}-${var.zone-id}-nsg-private"
  location            = var.location
  resource_group_name = var.resourcegroup_name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_security_rule" "nsr-ingress-private-all" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-ingress-all"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-private.name
}

resource "azurerm_network_security_rule" "nsr-egress-private-all" {
  name                        = "${var.prefix}-${var.zone-id}-nsr-egress-all"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resourcegroup_name
  network_security_group_name = azurerm_network_security_group.nsg-private.name
}