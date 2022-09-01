resource "random_id" "randomId" {
  byte_length = 8
}

resource "azurerm_storage_account" "fgtstorageaccount-regiona" {
  name                     = "stgra${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg-regiona.name
  location                 = var.regiona
  account_replication_type = "LRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"

  tags = {
    environment = var.tag_env
  }
}

resource "azurerm_storage_account" "fgtstorageaccount-regionb" {
  name                     = "stgrb${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg-regionb.name
  location                 = var.regionb
  account_replication_type = "LRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"

  tags = {
    environment = var.tag_env
  }
}
