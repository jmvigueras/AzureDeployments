output "regionA-ResourceGroup" {
  value = azurerm_resource_group.rg-regiona.name
}

output "regionB-ResourceGroup" {
  value = azurerm_resource_group.rg-regionb.name
}

output "za-fgt-active-mgmt-url"{
  value = "https://${module.vnet-fgt-regiona.fgt-active-mgmt-ip}:${var.adminsport}"
}

output "za-fgt-passive-mgmt-url"{
  value = "https://${module.vnet-fgt-regiona.fgt-passive-mgmt-ip}:${var.adminsport}"
}

output "za-cluster-public-ip_ip"{
  value = module.vnet-fgt-regiona.cluster-public-ip_ip
}

output "zb-fgt-active-mgmt-url"{
  value = "https://${module.vnet-fgt-regionb.fgt-active-mgmt-ip}:${var.adminsport}"
}

output "zb-fgt-passive-mgmt-url"{
  value = "https://${module.vnet-fgt-regionb.fgt-passive-mgmt-ip}:${var.adminsport}"
}

output "zb-cluster-public-ip_ip"{
  value = module.vnet-fgt-regionb.cluster-public-ip_ip
}

output "site-fgt-mgmt-ip_url"{
  value = "https://${module.vnet-site-regiona.site-fgt-mgmt-ip_ip}:${var.adminsport}"
}

output "za-TestVM-spoke-1-ip"{
  value = azurerm_network_interface.za-ni-vm-spoke-1.private_ip_address
}

output "za-TestVM-spoke-2-ip"{
  value = azurerm_network_interface.za-ni-vm-spoke-2.private_ip_address
}

output "zb-TestVM-spoke-1-ip"{
  value = azurerm_network_interface.zb-ni-vm-spoke-1.private_ip_address
}

output "zb-TestVM-spoke-2-ip"{
  value = azurerm_network_interface.zb-ni-vm-spoke-2.private_ip_address
}

output "TestVM-site-ip"{
  value = azurerm_network_interface.za-ni-vm-site-1.private_ip_address
}

output "Username" {
  value = var.adminusername
}

output "Password" {
  value = var.adminpassword
}

output "advpn_ipsec-psk-key" {
  value = var.advpn-ipsec-psk
}
