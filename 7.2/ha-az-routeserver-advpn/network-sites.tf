
// Create vnet, subnet, ips for site1

resource "azurerm_virtual_network" "vnet-site1" {
  name                = "${var.prefix}-vnet-site1"
  address_space       = [cidrsubnet(var.spokes-onprem-cidr,8,1)]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet" "subnet-mgmt-site1" {
  name                 = "${var.prefix}-subnet-mgmt-site1"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-site1.name
  address_prefixes     = [cidrsubnet(var.spokes-onprem-cidr,11,8)]
}

resource "azurerm_subnet" "subnet-public-site1" {
  name                 = "${var.prefix}-subnet-public-site1"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-site1.name
  address_prefixes     = [cidrsubnet(var.spokes-onprem-cidr,11,9)]
}

resource "azurerm_subnet" "subnet-internal-site1" {
  name                 = "${var.prefix}-subnet-internal-site1"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-site1.name
  address_prefixes     = [cidrsubnet(var.spokes-onprem-cidr,11,10)]
}


resource "azurerm_public_ip" "site1-mgmt-ip" {
  name                = "${var.prefix}-site1-mgmt-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_public_ip" "site1-public-ip" {
  name                = "${var.prefix}-site1-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-site1-port1" {
  name                          = "${var.prefix}-ni-site1-port1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-mgmt-site1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-mgmt-site1.address_prefixes[0],10)
    public_ip_address_id          = azurerm_public_ip.site1-mgmt-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-site1-port2" {
  name                          = "${var.prefix}-ni-site1-port2"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public-site1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public-site1.address_prefixes[0],10)
    public_ip_address_id          = azurerm_public_ip.site1-public-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-site1-port3" {
  name                          = "${var.prefix}-ni-site1-port3"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-internal-site1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-internal-site1.address_prefixes[0],10)
  }

  tags = {
    environment = var.tag_env
  }
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "site1-port1nsg" {
  depends_on                = [azurerm_network_interface.ni-site1-port1]
  network_interface_id      = azurerm_network_interface.ni-site1-port1.id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt-ha.id
}

resource "azurerm_network_interface_security_group_association" "site1-port2nsg" {
  depends_on                = [azurerm_network_interface.ni-site1-port2]
  network_interface_id      = azurerm_network_interface.ni-site1-port2.id
  network_security_group_id = azurerm_network_security_group.nsg-public.id
}

resource "azurerm_network_interface_security_group_association" "site1-port3nsg" {
  depends_on                = [azurerm_network_interface.ni-site1-port3]
  network_interface_id      = azurerm_network_interface.ni-site1-port3.id
  network_security_group_id = azurerm_network_security_group.nsg-private.id
}


// Create vnet, subnet, ips for site2

resource "azurerm_virtual_network" "vnet-site2" {
  name                = "${var.prefix}-vnet-site2"
  address_space       = [cidrsubnet(var.spokes-onprem-cidr,8,2)]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_subnet" "subnet-mgmt-site2" {
  name                 = "${var.prefix}-subnet-mgmt-site2"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-site2.name
  address_prefixes     = [cidrsubnet(var.spokes-onprem-cidr,11,16)]
}

resource "azurerm_subnet" "subnet-public-site2" {
  name                 = "${var.prefix}-subnet-public-site2"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-site2.name
  address_prefixes     = [cidrsubnet(var.spokes-onprem-cidr,11,17)]
}

resource "azurerm_subnet" "subnet-internal-site2" {
  name                 = "${var.prefix}-subnet-internal-site2"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.vnet-site2.name
  address_prefixes     = [cidrsubnet(var.spokes-onprem-cidr,11,18)]
}


resource "azurerm_public_ip" "site2-mgmt-ip" {
  name                = "${var.prefix}-site2-mgmt-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_public_ip" "site2-public-ip" {
  name                = "${var.prefix}-site2-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-site2-port1" {
  name                          = "${var.prefix}-ni-site2-port1"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-mgmt-site2.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-mgmt-site2.address_prefixes[0],10)
    public_ip_address_id          = azurerm_public_ip.site2-mgmt-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-site2-port2" {
  name                          = "${var.prefix}-ni-site2-port2"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-public-site2.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-public-site2.address_prefixes[0],10)
    public_ip_address_id          = azurerm_public_ip.site2-public-ip.id
  }

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_network_interface" "ni-site2-port3" {
  name                          = "${var.prefix}-ni-site2-port3"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = var.accelerate == "true" ? true : false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-internal-site2.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(azurerm_subnet.subnet-internal-site2.address_prefixes[0],10)
  }

  tags = {
    environment = var.tag_env
  }
}

# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "site2-port1nsg" {
  depends_on                = [azurerm_network_interface.ni-site2-port1]
  network_interface_id      = azurerm_network_interface.ni-site2-port1.id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt-ha.id
}

resource "azurerm_network_interface_security_group_association" "site2-port2nsg" {
  depends_on                = [azurerm_network_interface.ni-site2-port2]
  network_interface_id      = azurerm_network_interface.ni-site2-port2.id
  network_security_group_id = azurerm_network_security_group.nsg-public.id
}

resource "azurerm_network_interface_security_group_association" "site2-port3nsg" {
  depends_on                = [azurerm_network_interface.ni-site2-port3]
  network_interface_id      = azurerm_network_interface.ni-site2-port3.id
  network_security_group_id = azurerm_network_security_group.nsg-private.id
}


