output "a_ResourceGroup" {
  value = azurerm_resource_group.myterraformgroup.name
}

output "b_clusterPublicIP" {
  value = azurerm_public_ip.cluster-public-ip.ip_address
}

output "c_ActiveMGMTPublicIP" {
  value = "https://${azurerm_public_ip.active-mgmt-ip.ip_address}:${var.adminsport}"
}


output "d_PassiveMGMTPublicIP" {
  value = "https://${azurerm_public_ip.passive-mgmt-ip.ip_address}:${var.adminsport}"
}

output "e_TestVMSpokeAIP"{
  value = azurerm_network_interface.ni-vm-spokea.private_ip_address
}

output "f_TestVMSpokeBIP"{
  value = azurerm_network_interface.ni-vm-spokeb.private_ip_address
}

output "g_TestVMSpokeCIP"{
  value = azurerm_network_interface.ni-vm-spokec.private_ip_address
}

output "h_Username" {
  value = var.adminusername
}

output "i_Password" {
  value = var.adminpassword
}

output "j_advpn_ipsec-psk-key" {
  value = var.advpn-ipsec-psk
}

output "k_advpn-public-ip" {
  value = azurerm_public_ip.cluster-public-ip.ip_address
}

output "l_Site1MGMTIP" {
  value = "https://${azurerm_public_ip.site1-mgmt-ip.ip_address}:${var.adminsport}"
}

output "m_Site2MGMTIP" {
  value = "https://${azurerm_public_ip.site2-mgmt-ip.ip_address}:${var.adminsport}"
}

output "n_TestVMSite1IP"{
  value = azurerm_network_interface.ni-vm-site1.private_ip_address
}

output "o_TestVMSite2IP"{
  value = azurerm_network_interface.ni-vm-site2.private_ip_address
}