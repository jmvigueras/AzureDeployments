// Create Spoke A

resource "azurerm_virtual_network" "vnet-spokea" {
  name                = "${var.prefix}-vnet-spokea"
  address_space       = [var.spokeacidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet" "subnet-spokea" {
  name                 = "${var.prefix}-subnet-spokea"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-spokea.name
  address_prefixes     = [var.spokeasubnetcidr]
}

// Create Spoke B

resource "azurerm_virtual_network" "vnet-spokeb" {
  name                = "${var.prefix}-vnet-spokeB"
  address_space       = [var.spokebcidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet" "subnet-spokeb" {
  name                 = "${var.prefix}-subnet-spokeb"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-spokeb.name
  address_prefixes     = [var.spokebsubnetcidr]
}

// Create Virtual Network FGT

resource "azurerm_virtual_network" "vnet-fgt" {
  name                = "${var.prefix}-vnet-fgt"
  address_space       = [var.vnetcidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet" "subnet-public" {
  name                 = "${var.prefix}-subnet-public"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [var.publiccidr]
}

resource "azurerm_subnet" "subnet-private" {
  name                 = "${var.prefix}-subnet-private"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [var.privatecidr]
}

resource "azurerm_subnet" "subnet-hamgmt" {
  name                 = "${var.prefix}-subnet-hamgmt"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-fgt.name
  address_prefixes     = [var.hamgmtcidr]
}


// Allocated Public IPs
resource "azurerm_public_ip" "cluster-ip" {
  name                = "${var.prefix}-cluster-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_public_ip" "active-mgmt-ip" {
  name                = "${var.prefix}-active-mgmt-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_public_ip" "passive-mgmt-ip" {
  name                = "${var.prefix}-passive-mgmt-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

// Active FGT Network Interface port1
resource "azurerm_network_interface" "ni-activeport1" {
  name                          = "${var.prefix}-ni-activeport1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-hamgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport1
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.active-mgmt-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-activeport2" {
  name                          = "${var.prefix}-ni-activeport2"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport2
    public_ip_address_id          = azurerm_public_ip.cluster-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-activeport3" {
  name                          = "${var.prefix}-ni-activeport3"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport3
  }

  tags = {
    environment = var.tag_env
  }
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "port1nsg" {
  depends_on                = [azurerm_network_interface.ni-activeport1]
  network_interface_id      = azurerm_network_interface.ni-activeport1.id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt-ha.id
}

resource "azurerm_network_interface_security_group_association" "port2nsg" {
  depends_on                = [azurerm_network_interface.ni-activeport2]
  network_interface_id      = azurerm_network_interface.ni-activeport2.id
  network_security_group_id = azurerm_network_security_group.nsg-public.id
}

resource "azurerm_network_interface_security_group_association" "port3nsg" {
  depends_on                = [azurerm_network_interface.ni-activeport3]
  network_interface_id      = azurerm_network_interface.ni-activeport3.id
  network_security_group_id = azurerm_network_security_group.nsg-private.id
}

// Passive FGT Network Interface port1
resource "azurerm_network_interface" "ni-passiveport1" {
  name                          = "${var.prefix}-ni-passiveport1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-hamgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport1
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.passive-mgmt-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-passiveport2" {
  name                          = "${var.prefix}-ni-passiveport2"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport2
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-passiveport3" {
  name                          = "${var.prefix}-ni-passiveport3"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport3
  }

  tags = {
    environment = var.tag_env
  }
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "passiveport1nsg" {
  depends_on                = [azurerm_network_interface.ni-passiveport1]
  network_interface_id      = azurerm_network_interface.ni-passiveport1.id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt-ha.id
}

resource "azurerm_network_interface_security_group_association" "passiveport2nsg" {
  depends_on                = [azurerm_network_interface.ni-passiveport2]
  network_interface_id      = azurerm_network_interface.ni-passiveport2.id
  network_security_group_id = azurerm_network_security_group.nsg-public.id
}

resource "azurerm_network_interface_security_group_association" "passiveport3nsg" {
  depends_on                = [azurerm_network_interface.ni-passiveport3]
  network_interface_id      = azurerm_network_interface.ni-passiveport3.id
  network_security_group_id = azurerm_network_security_group.nsg-private.id
}


// Peering SpokeA with VPC Fortinet

resource "azurerm_virtual_network_peering" "peerSpokeAtoFGT-1" {
  name                      = "${var.prefix}-peerSpokeAtoFGT-1"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name
  virtual_network_name      = azurerm_virtual_network.vnet-fgt.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-spokea.id
}

resource "azurerm_virtual_network_peering" "peerSpokeAtoFGT-2" {
  name                      = "${var.prefix}-peerSpokeAtoFGT-2"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name
  virtual_network_name      = azurerm_virtual_network.vnet-spokea.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-fgt.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerSpokeBtoFGT-1" {
  name                      = "${var.prefix}-peerSpokeBtoFGT-1"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name
  virtual_network_name      = azurerm_virtual_network.vnet-fgt.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-spokeb.id
}

resource "azurerm_virtual_network_peering" "peerSpokeBtoFGT-2" {
  name                      = "${var.prefix}-peerSpokeBtoFGT-2"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name
  virtual_network_name      = azurerm_virtual_network.vnet-spokeb.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-fgt.id
  allow_forwarded_traffic   = true
}

