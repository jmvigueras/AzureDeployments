// Resource Group

resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    environment = var.tag_env
  }
}
