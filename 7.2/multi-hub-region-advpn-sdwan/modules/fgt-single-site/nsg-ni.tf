# Connect the security group to the network interfaces FGT active
resource "azurerm_network_interface_security_group_association" "activeport1nsg" {
  network_interface_id      = var.fgt-ni_ids[0]
  network_security_group_id = var.fgt-ni-nsg_ids[0]
}

resource "azurerm_network_interface_security_group_association" "activeport2nsg" {
  network_interface_id      = var.fgt-ni_ids[1]
  network_security_group_id = var.fgt-ni-nsg_ids[1]
}

resource "azurerm_network_interface_security_group_association" "activeport3nsg" {
  network_interface_id      = var.fgt-ni_ids[2]
  network_security_group_id = var.fgt-ni-nsg_ids[2]
}
