// Create Spoke A

resource "azurerm_virtual_network" "spokea" {
  name                = "spokeA"
  address_space       = [var.spokeacidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_subnet" "spokeasubnet" {
  name                 = "spokeAsubnet01"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.spokea.name
  address_prefixes     = [var.spokeasubnetcidr]
}

// Create Spoke B

resource "azurerm_virtual_network" "spokeb" {
  name                = "spokeB"
  address_space       = [var.spokebcidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_subnet" "spokebsubnet" {
  name                 = "spokeBsubnet01"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.spokeb.name
  address_prefixes     = [var.spokebsubnetcidr]
}

// Create Virtual Network

resource "azurerm_virtual_network" "fgtvnetwork" {
  name                = "fgtvnetwork"
  address_space       = [var.vnetcidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_subnet" "publicsubnet" {
  name                 = "publicSubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  address_prefixes     = [var.publiccidr]
}

resource "azurerm_subnet" "privatesubnet" {
  name                 = "privateSubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  address_prefixes     = [var.privatecidr]
}

resource "azurerm_subnet" "hamgmtsubnet" {
  name                 = "HAMGMTSubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork.name
  address_prefixes     = [var.hamgmtcidr]
}


// Allocated Public IP
resource "azurerm_public_ip" "ClusterPublicIP" {
  name                = "ClusterPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_public_ip" "ActiveMGMTIP" {
  name                = "ActiveMGMTIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_public_ip" "PassiveMGMTIP" {
  name                = "PassiveMGMTIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = "Terraform Demo"
  }
}

//  Network Security Group
resource "azurerm_network_security_group" "publicnetworknsg" {
  name                = "PublicNetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "TCP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_security_group" "privatenetworknsg" {
  name                = "PrivateNetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "All"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_security_rule" "outgoing_public" {
  name                        = "egress"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.publicnetworknsg.name
}

resource "azurerm_network_security_rule" "outgoing_private" {
  name                        = "egress-private"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.privatenetworknsg.name
}


// Active FGT Network Interface port1
resource "azurerm_network_interface" "activeport1" {
  name                          = "activeport1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.hamgmtsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport1
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.ActiveMGMTIP.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "activeport2" {
  name                          = "activeport2"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport2
    public_ip_address_id          = azurerm_public_ip.ClusterPublicIP.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "activeport3" {
  name                          = "activeport3"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.privatesubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.activeport3
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "port1nsg" {
  depends_on                = [azurerm_network_interface.activeport1]
  network_interface_id      = azurerm_network_interface.activeport1.id
  network_security_group_id = azurerm_network_security_group.publicnetworknsg.id
}

resource "azurerm_network_interface_security_group_association" "port2nsg" {
  depends_on                = [azurerm_network_interface.activeport2]
  network_interface_id      = azurerm_network_interface.activeport2.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg.id
}

resource "azurerm_network_interface_security_group_association" "port3nsg" {
  depends_on                = [azurerm_network_interface.activeport3]
  network_interface_id      = azurerm_network_interface.activeport3.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg.id
}

// Passive FGT Network Interface port1
resource "azurerm_network_interface" "passiveport1" {
  name                          = "passiveport1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.hamgmtsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport1
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.PassiveMGMTIP.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "passiveport2" {
  name                          = "passiveport2"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport2
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "passiveport3" {
  name                          = "passiveport3"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.privatesubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.passiveport3
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "passiveport1nsg" {
  depends_on                = [azurerm_network_interface.passiveport1]
  network_interface_id      = azurerm_network_interface.passiveport1.id
  network_security_group_id = azurerm_network_security_group.publicnetworknsg.id
}

resource "azurerm_network_interface_security_group_association" "passiveport2nsg" {
  depends_on                = [azurerm_network_interface.passiveport2]
  network_interface_id      = azurerm_network_interface.passiveport2.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg.id
}

resource "azurerm_network_interface_security_group_association" "passiveport3nsg" {
  depends_on                = [azurerm_network_interface.passiveport3]
  network_interface_id      = azurerm_network_interface.passiveport3.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg.id
}


// Peering SpokeA with VPC Fortinet

resource "azurerm_virtual_network_peering" "peerSpokeAtoFGT-1" {
  name                      = "peerSpokeAtoFGT"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name
  virtual_network_name      = azurerm_virtual_network.fgtvnetwork.name
  remote_virtual_network_id = azurerm_virtual_network.spokea.id
}

resource "azurerm_virtual_network_peering" "peerSpokeAtoFGT-2" {
  name                      = "peerFGTtoSpokeA"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name
  virtual_network_name      = azurerm_virtual_network.spokea.name
  remote_virtual_network_id = azurerm_virtual_network.fgtvnetwork.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerSpokeBtoFGT-1" {
  name                      = "peerSpokeBtoFGT"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name
  virtual_network_name      = azurerm_virtual_network.fgtvnetwork.name
  remote_virtual_network_id = azurerm_virtual_network.spokeb.id
}

resource "azurerm_virtual_network_peering" "peerSpokeBtoFGT-2" {
  name                      = "peerFGTtoSpokeB"
  resource_group_name       = azurerm_resource_group.myterraformgroup.name
  virtual_network_name      = azurerm_virtual_network.spokeb.name
  remote_virtual_network_id = azurerm_virtual_network.fgtvnetwork.id
  allow_forwarded_traffic   = true
}

