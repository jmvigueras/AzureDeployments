output "nsg-public_id"{
  value = azurerm_network_security_group.nsg-public.id
}

output "nsg-private_id"{
  value = azurerm_network_security_group.nsg-private.id
}

output "nsg-mgmt-ha_id"{
  value = azurerm_network_security_group.nsg-mgmt-ha.id
}

output "nsg_ids"{
  value = {
    "nsg-mgmt"    = azurerm_network_security_group.nsg-mgmt-ha.id
    "nsg-public"  = azurerm_network_security_group.nsg-public.id
    "nsg-private" = azurerm_network_security_group.nsg-private.id
  }
}


