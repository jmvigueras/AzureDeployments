// Create Virtual Network FGT

resource "azurerm_virtual_network" "vnet-fgt" {
  name                = "${var.prefix}-${var.zone-id}-vnet-fgt"
  address_space       = [var.vnet-fgt-cidr]
  location            = var.location
  resource_group_name = var.resourcegroup_name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet" "subnet-hamgmt" {
  name                 = "${var.prefix}-${var.zone-id}-subnet-hamgmt"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt-cidr,4,1)]
}

resource "azurerm_subnet" "subnet-public" {
  name                 = "${var.prefix}-${var.zone-id}-subnet-public"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt-cidr,4,2)]
}

resource "azurerm_subnet" "subnet-private" {
  name                 = "${var.prefix}-${var.zone-id}-subnet-private"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt-cidr,4,3)]
}

resource "azurerm_subnet" "subnet-advpn" {
  name                 = "${var.prefix}-${var.zone-id}-subnet-advpn"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt-cidr,4,4)]
}

resource "azurerm_subnet" "subnet-vgw" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [cidrsubnet(var.vnet-fgt-cidr,4,5)]
}


// Allocated Public IPs
resource "azurerm_public_ip" "cluster-public-ip" {
  name                = "${var.prefix}-${var.zone-id}-cluster-public-ip"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_public_ip" "active-mgmt-ip" {
  name                = "${var.prefix}-${var.zone-id}-active-mgmt-ip"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_public_ip" "passive-mgmt-ip" {
  name                = "${var.prefix}-${var.zone-id}-passive-mgmt-ip"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

// Active FGT Network Interface port1
resource "azurerm_network_interface" "ni-activeport1" {
  name                          = "${var.prefix}-${var.zone-id}-ni-activeport1"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-hamgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-hamgmt.address_prefixes[0],10)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.active-mgmt-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-activeport2" {
  name                          = "${var.prefix}-${var.zone-id}-ni-activeport2"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public.address_prefixes[0],10)
    public_ip_address_id          = azurerm_public_ip.cluster-public-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-activeport3" {
  name                          = "${var.prefix}-${var.zone-id}-ni-activeport3"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-private.address_prefixes[0],10)
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-activeport4" {
  name                          = "${var.prefix}-${var.zone-id}-ni-activeport4"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-advpn.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-advpn.address_prefixes[0],10)
  }

  tags = {
    environment = var.tag_env
  }
}


// Passive FGT Network Interface port1
resource "azurerm_network_interface" "ni-passiveport1" {
  name                          = "${var.prefix}-${var.zone-id}-ni-passiveport1"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-hamgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-hamgmt.address_prefixes[0],11)
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.passive-mgmt-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-passiveport2" {
  name                          = "${var.prefix}-${var.zone-id}-ni-passiveport2"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public.address_prefixes[0],11)
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-passiveport3" {
  name                          = "${var.prefix}-${var.zone-id}-ni-passiveport3"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-private.address_prefixes[0],11)
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-passiveport4" {
  name                          = "${var.prefix}-${var.zone-id}-ni-passiveport4"
  location                      = var.location
  resource_group_name           = var.resourcegroup_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-advpn.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-advpn.address_prefixes[0],11)
  }

  tags = {
    environment = var.tag_env
  }
}

// Create VNET spokes 1 and subnets

resource "azurerm_virtual_network" "vnet-spoke-1" {
  name                = "${var.prefix}-${var.zone-id}-vnet-fgt-spoke-1"
  address_space       = [var.vnet-spoke-1-cidr]
  location            = var.location
  resource_group_name = var.resourcegroup_name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet" "subnet-spoke-1" {
  name                 = "${var.prefix}-${var.zone-id}-subnet-fgt-spoke-1"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-1.name
  address_prefixes     = [cidrsubnet(var.vnet-spoke-1-cidr,1,0)]
}

resource "azurerm_subnet" "subnet-spoke-1-RouteServerSubnet" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-1.name
  address_prefixes     = [cidrsubnet(var.vnet-spoke-1-cidr,3,4)]
}

// Create VNET spokes 2 and subnets

resource "azurerm_virtual_network" "vnet-spoke-2" {
  name                = "${var.prefix}-${var.zone-id}-vnet-fgt-spoke-2"
  address_space       = [var.vnet-spoke-2-cidr]
  location            = var.location
  resource_group_name = var.resourcegroup_name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet" "subnet-spoke-2" {
  name                 = "${var.prefix}-${var.zone-id}-subnet-fgt-spoke-2"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-2.name
  address_prefixes     = [cidrsubnet(var.vnet-spoke-2-cidr,1,0)]
}

resource "azurerm_subnet" "subnet-spoke-2-RouteServerSubnet" {
  name                 = "RouteServerSubnet"
  resource_group_name  = var.resourcegroup_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-2.name
  address_prefixes     = [cidrsubnet(var.vnet-spoke-2-cidr,3,4)]
}

// Peering SpokeA with VPC Fortinet

resource "azurerm_virtual_network_peering" "peerSpoke1toFGT-1" {
  name                      = "${var.prefix}-${var.zone-id}-peerSpokeAtoFGT-1"
  resource_group_name       = var.resourcegroup_name
  virtual_network_name      = azurerm_virtual_network.vnet-fgt.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke-1.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerSpoke1toFGT-2" {
  name                      = "${var.prefix}-${var.zone-id}-peerSpokeAtoFGT-2"
  resource_group_name       = var.resourcegroup_name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke-1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-fgt.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerSpoke2toFGT-1" {
  name                      = "${var.prefix}-${var.zone-id}-peerSpokeBtoFGT-1"
  resource_group_name       = var.resourcegroup_name
  virtual_network_name      = azurerm_virtual_network.vnet-fgt.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke-2.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerSpoke2toFGT-2" {
  name                      = "${var.prefix}-${var.zone-id}-peerSpokeBtoFGT-2"
  resource_group_name       = var.resourcegroup_name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke-2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-fgt.id
  allow_forwarded_traffic   = true
}


