output "fgt-active-mgmt-ip"{
  value = azurerm_public_ip.active-mgmt-ip.ip_address
}

output "fgt-passive-mgmt-ip"{
  value = azurerm_public_ip.passive-mgmt-ip.ip_address
}

output "cluster-public-ip_ip"{
  value = azurerm_public_ip.cluster-public-ip.ip_address
}

output "cluster-public-ip_name"{
  value = azurerm_public_ip.cluster-public-ip.name
}

output "vnet-fgt_id"{
  value = azurerm_virtual_network.vnet-fgt.id
}

output "vnet-fgt_name"{
  value = azurerm_virtual_network.vnet-fgt.name
}

output "vnet-fgt-spoke" {
  value = {
    "1_name" = azurerm_virtual_network.vnet-spoke-1.name
    "1_net"  = azurerm_virtual_network.vnet-spoke-1.address_space[0]
    "2_name" = azurerm_virtual_network.vnet-spoke-2.name
    "2_net"  = azurerm_virtual_network.vnet-spoke-2.address_space[0]
  }
}

output "fgt-active-ni_ids" {
  value = {
    "port1" = azurerm_network_interface.ni-activeport1.id
    "port2" = azurerm_network_interface.ni-activeport2.id
    "port3" = azurerm_network_interface.ni-activeport3.id
    "port4" = azurerm_network_interface.ni-activeport4.id
  }
}

output "fgt-active-ni_names"{
  value = [azurerm_network_interface.ni-activeport1.name, azurerm_network_interface.ni-activeport2.name, azurerm_network_interface.ni-activeport3.name, azurerm_network_interface.ni-activeport4.name]
}

output "fgt-active-ni_ips"{
  value = {
    "port1" = azurerm_network_interface.ni-activeport1.private_ip_address
    "port2" = azurerm_network_interface.ni-activeport2.private_ip_address
    "port3" = azurerm_network_interface.ni-activeport3.private_ip_address
    "port4" = azurerm_network_interface.ni-activeport4.private_ip_address
  }
}

output "fgt-passive-ni_ids"{
  value = {
    "port1" = azurerm_network_interface.ni-passiveport1.id
    "port2" = azurerm_network_interface.ni-passiveport2.id
    "port3" = azurerm_network_interface.ni-passiveport3.id
    "port4" = azurerm_network_interface.ni-passiveport4.id
  }
}

output "fgt-passive-ni_names"{
  value = [azurerm_network_interface.ni-passiveport1.name, azurerm_network_interface.ni-passiveport2.name, azurerm_network_interface.ni-passiveport3.name, azurerm_network_interface.ni-passiveport4.name]
}

output "fgt-passive-ni_ips"{
  value = {
    "port1" = azurerm_network_interface.ni-passiveport1.private_ip_address
    "port2" = azurerm_network_interface.ni-passiveport2.private_ip_address
    "port3" = azurerm_network_interface.ni-passiveport3.private_ip_address
    "port4" = azurerm_network_interface.ni-passiveport4.private_ip_address
  }
}

output "subnets-vnet-fgt_nets"{
  value = {
    "mgmt"      = azurerm_subnet.subnet-hamgmt.address_prefixes[0]
    "public"    = azurerm_subnet.subnet-public.address_prefixes[0]
    "private"   = azurerm_subnet.subnet-private.address_prefixes[0]
    "advpn"     = azurerm_subnet.subnet-advpn.address_prefixes[0]
  }
}

output "subnets-vnet-fgt_names"{
  value = { 
    "mgmt"    = azurerm_subnet.subnet-hamgmt.name
    "public"  = azurerm_subnet.subnet-public.name
    "private" = azurerm_subnet.subnet-private.name
    "advpn"   = azurerm_subnet.subnet-advpn.name
    "vgw"     = azurerm_subnet.subnet-vgw.name
  }
}

output "subnets-vnet-fgt_ids"{
  value = {
    "mgmt"    = azurerm_subnet.subnet-hamgmt.id
    "public"  = azurerm_subnet.subnet-public.id
    "private" = azurerm_subnet.subnet-private.id
    "advpn"   = azurerm_subnet.subnet-advpn.id
    "vgw"     = azurerm_subnet.subnet-vgw.id
  }
}

output "subnets-spokes_ids"{
  value = {
    "n-spoke-vm-1" = azurerm_subnet.subnet-spoke-1.id
    "n-spoke-vm-2" = azurerm_subnet.subnet-spoke-2.id
    "n-spoke-rs-1" = azurerm_subnet.subnet-spoke-1-RouteServerSubnet.id
    "n-spoke-rs-2" = azurerm_subnet.subnet-spoke-2-RouteServerSubnet.id
  }
}

output "subnets-spokes_names"{
  value = {
    "n-spoke-vm-1" = azurerm_subnet.subnet-spoke-1.name
    "n-spoke-vm-2" = azurerm_subnet.subnet-spoke-2.name
    "n-spoke-rs-1" = azurerm_subnet.subnet-spoke-1-RouteServerSubnet.name
    "n-spoke-rs-2" = azurerm_subnet.subnet-spoke-2-RouteServerSubnet.name
  }
}

output "subnets-spokes_nets"{
  value = {
    "n-spoke-vm-1" = azurerm_subnet.subnet-spoke-1.address_prefixes[0]
    "n-spoke-vm-2" = azurerm_subnet.subnet-spoke-2.address_prefixes[0]
    "n-spoke-rs-1" = azurerm_subnet.subnet-spoke-1-RouteServerSubnet.address_prefixes[0]
    "n-spoke-rs-1" = azurerm_subnet.subnet-spoke-2-RouteServerSubnet.address_prefixes[0]
  }
}

output "subnets-spokes" {
  value = {
    "n-spoke-vm-1_net" = azurerm_subnet.subnet-spoke-1.address_prefixes[0]
    "n-spoke-vm-2_net" = azurerm_subnet.subnet-spoke-2.address_prefixes[0]
    "n-spoke-rs-1_net" = azurerm_subnet.subnet-spoke-1-RouteServerSubnet.address_prefixes[0]
    "n-spoke-rs-2_net" = azurerm_subnet.subnet-spoke-2-RouteServerSubnet.address_prefixes[0]
    "n-spoke-vm-1_name" = azurerm_subnet.subnet-spoke-1.name
    "n-spoke-vm-2_name" = azurerm_subnet.subnet-spoke-2.name
    "n-spoke-rs-1_name" = azurerm_subnet.subnet-spoke-1-RouteServerSubnet.name
    "n-spoke-rs-2_name" = azurerm_subnet.subnet-spoke-2-RouteServerSubnet.name
    "n-spoke-vm-1_id" = azurerm_subnet.subnet-spoke-1.id
    "n-spoke-vm-2_id" = azurerm_subnet.subnet-spoke-2.id
    "n-spoke-rs-1_id" = azurerm_subnet.subnet-spoke-1-RouteServerSubnet.id
    "n-spoke-rs-2_id" = azurerm_subnet.subnet-spoke-2-RouteServerSubnet.id
  }
}

