output "site-fgt-mgmt-ip_ip"{
  value = azurerm_public_ip.site-fgt-mgmt-ip.ip_address
}

output "site-fgt-public_name"{
  value = azurerm_public_ip.site-fgt-public-ip.ip_address
}

output "fgt-site-ni_ids"{
  value = {
    "port1" = azurerm_network_interface.ni-site-port1.id
    "port2" = azurerm_network_interface.ni-site-port2.id
    "port3" = azurerm_network_interface.ni-site-port3.id
  }
}

output "fgt-site-ni_names"{
  value = [azurerm_network_interface.ni-site-port1.name, azurerm_network_interface.ni-site-port2.name, azurerm_network_interface.ni-site-port3.name]
}

output "fgt-site-ni_ips"{
  value = {
    "port1" = azurerm_network_interface.ni-site-port1.private_ip_address
    "port2" = azurerm_network_interface.ni-site-port2.private_ip_address
    "port3" = azurerm_network_interface.ni-site-port3.private_ip_address
  }
}

output "subnets-vnet-fgt_nets"{
  value = {
    "mgmt"      = azurerm_subnet.subnet-hamgmt.address_prefixes[0]
    "public"    = azurerm_subnet.subnet-public.address_prefixes[0]
    "private"   = azurerm_subnet.subnet-private.address_prefixes[0]
    "vgw"       = azurerm_subnet.subnet-vgw.address_prefixes[0]
  }
}

output "subnets-vnet-fgt_names"{
  value = {
    "mgmt"      = azurerm_subnet.subnet-hamgmt.name 
    "public"    = azurerm_subnet.subnet-public.name
    "private"   = azurerm_subnet.subnet-private.name
    "vgw"       = azurerm_subnet.subnet-vgw.name
  }
}

output "subnets-vnet-fgt_ids"{
  value = {
    "mgmt"      = azurerm_subnet.subnet-hamgmt.id
    "public"    = azurerm_subnet.subnet-public.id
    "private"   = azurerm_subnet.subnet-private.id
    "vgw"       =  azurerm_subnet.subnet-vgw.id
  }
}

output "subnets-site-peer"{
  value = {
    "1_name" = azurerm_subnet.subnet-site-spoke.name
    "1_net"  = azurerm_subnet.subnet-site-spoke.address_prefixes[0]
    "1_id"   = azurerm_subnet.subnet-site-spoke.id
  }
}