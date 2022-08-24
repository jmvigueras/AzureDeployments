resource "azurerm_storage_account" "fgtstorageaccount" {
  name                     = "staccount${var.prefix}"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"

  tags = {
    environment = var.tag_env
  }
}
